"""
SQLAlchemy model of the Qubit Toolkit database.
"""

import re
import datetime

from sqlalchemy import create_engine, MetaData
from sqlalchemy.orm import sessionmaker, MapperExtension
from sqlalchemy.sql import and_, or_, not_
from sqlalchemy.ext.declarative import declarative_base, declared_attr
from sqlalchemy import Column, String, Integer, Float, Boolean, Text, DateTime, ForeignKey
from sqlalchemy import select, case, func, Table
from sqlalchemy.orm import relationship, backref, mapper
import sqlalchemy

engine = create_engine("mysql+mysqldb://qubit:changeme@localhost/test_ehriqubit")
Session = sessionmaker(bind=engine)


Base = declarative_base(bind=engine)

metadata = MetaData(engine)


def cc2us(name):
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()


def annotate_i18n(cls):
    """Decorator for generating an I18N table
    for the given source table, and placing
    an accessor relationship on the source."""
    tablename = cls.__tablename__ + "_i18n"
    classname = cls.__name__ + "I18N"
    i18nt = Table(tablename, Base.metadata, 
            Column("id", ForeignKey("%s.id" % cls.__tablename__),
                    primary_key=True),
            Column("culture", String(25), primary_key=True),
            autoload=True)
    globals()[classname] = type(classname, (Base,), dict(__table__=i18nt))
    setattr(cls, tablename, relationship(classname, cascade="all,delete-orphan"))
    return cls


class NestedSetExtension(MapperExtension):
    def before_insert(self, mapper, connection, instance):
        table = instance.nested_object_table
        if not instance.parent:
            max = connection.scalar(func.max(table.c.rgt))
            instance.lft = max + 1
            instance.rgt = max + 2
        else:
            right_most_sibling = connection.scalar(
                select([table.c.rgt]).where(table.c.id==instance.parent.id)
            )

            connection.execute(
                table.update(table.c.rgt>=right_most_sibling).values(
                    lft = case(
                            [(table.c.lft>right_most_sibling, table.c.lft + 2)],
                            else_ = table.c.lft
                          ),
                    rgt = case(
                            [(table.c.rgt>=right_most_sibling, table.c.rgt + 2)],
                            else_ = table.c.rgt
                          )
                )
            )
            instance.lft = right_most_sibling
            instance.rgt = right_most_sibling + 1

    def before_update(self, mapper, connection, instance):
        table = instance.nested_object_table
        old_parent_id = connection.scalar(
                select([table.c.parent_id]).where(table.c.id==instance.id)
        )
        if old_parent_id != instance.parent_id:
            if instance.parent_id is None:
                # reparent any child nodes to the old parent
                connection.execute(
                    table.update(table.c.parent_id == old_parent_id).values(
                        parent_id = old_parent_id
                    )
                )

            # treat the node as deleted and inserted again
            self.before_delete(mapper, connection, instance)
            self.before_insert(mapper, connection, instance)

    def before_delete(self, mapper, connection, instance):
        """Delete nested tree values for this model."""
        table = instance.nested_object_table
        delta = instance.rgt - instance.lft + 1

        connection.execute(
            table.update(table.c.rgt>=instance.rgt).values(
                lft = case(
                    [(table.c.lft > instance.lft, table.c.lft - delta)],
                    else_ = table.c.lft
                ),
                rgt = case(
                    [(table.c.rgt >= instance.rgt, table.c.rgt - delta)],
                    else_ = table.c.rgt
                )
            )
        )


class NestedObjectMixin(object):
    """
    Mixin class for classes with lft/rgt heirarchy fields.  These creates a
    tree structure which allows for optimised traversal, as opposed to
    crawling the heirarchy via the database.
    """
    @declared_attr
    def parent_id(cls):
        return Column(Integer, ForeignKey(cls.id))

    @declared_attr
    def parent(cls):
        return relationship("%s" % cls.__name__,
                backref="children", order_by="%s.lft" % cls.__name__,
                remote_side="%s.id" % cls.__name__,
                primaryjoin=("%s.id==%s.parent_id" % (cls.__name__, cls.__name__)))

    @declared_attr
    def lft(cls):
        return Column(Integer)

    @declared_attr
    def rgt(cls):
        return Column(Integer)

    @classmethod
    def nested_object_table(cls):
        """When given a class which may inherit
        from a nested set object, find the nested
        base class and return it's table."""
        bases = cls.__bases__
        def check_bases(klass):
            if NestedObjectMixin in klass.__bases__:
                return klass
            for base in klass.__bases__:
                if check_bases(base):
                    return base
        nestedbase = check_bases(cls)
        if nestedbase is not None:
            return nestedbase.__table__


class I18NMixin(object):
    """Mixin class for objects that have an i18n table."""

    @declared_attr
    def source_culture(cls):
        return Column(String(7))

    @classmethod
    def _get_class_i18n(cls, session, klass, object_id, lang):
        """Get the I18N data for a given class, object id, and lang."""
        data = {}
        try:
            i18ncls = globals()[klass.__name__ + "I18N"]
        except KeyError:
            return data
        i18n = None
        try:
            i18n = session.query(i18ncls).filter(
                    and_(i18ncls.id==object_id, i18ncls.culture==lang)).one()
        except sqlalchemy.orm.exc.NoResultFound:
            pass
        for col, spec in dict(i18ncls.__table__.columns).iteritems():
            if spec.primary_key:
                continue
            data[col] = getattr(i18n, col) if i18n is not None else None
        return data

    @classmethod
    def _get_i18n(cls, session, object_id, lang):
        """Get i18n data for a given class AND it's
        base classes."""
        data = {}

        for baseclass in cls.__bases__:
            if hasattr(baseclass, "_get_i18n"):
                data.update(baseclass._get_i18n(session, object_id, lang))
        data.update(cls._get_class_i18n(session, cls, object_id, lang))
        return data

    def get_i18n(self, lang="en"):
        """Get i18n data for a given object."""
        session = Session.object_session(self)
        return self._get_i18n(session, self.id, lang)

    @classmethod
    def _set_class_i18n(cls, session, klass, object_id, lang, data):
        """Set the I18N data for a given class, object id, and lang."""
        try:
            i18ncls = globals()[klass.__name__ + "I18N"]
        except KeyError:
            return
        try:
            i18n = session.query(i18ncls).filter(
                    and_(i18ncls.id==object_id, i18ncls.culture==lang)).one()
        except sqlalchemy.orm.exc.NoResultFound:
            i18n = i18ncls(id=object_id, culture=lang)
            session.add(i18n)
        for col, spec in dict(i18ncls.__table__.columns).iteritems():
            if spec.primary_key:
                continue
            if data.get(col):
                setattr(i18n, col, data.get(col))

    @classmethod
    def _set_i18n(cls, session, object_id, lang, data):
        """Set the i18n data for a given class AND it's
        base classes."""
        for baseclass in cls.__bases__:
            if hasattr(baseclass, "_set_i18n"):
                baseclass._set_i18n(session, object_id, lang, data)
        cls._set_class_i18n(session, cls, object_id, lang, data)

    def set_i18n(self, data, lang="en"):
        """Set i18n data for a given object."""
        session = Session.object_session(self)
        self._set_i18n(session, self.id, lang, data)


class TimeStampMixin(object):
    """Auto add create/update timestamps."""
    @declared_attr
    def created_at(cls):
        return Column(DateTime, default=datetime.datetime.now())

    @declared_attr
    def updated_at(cls):
        return Column(DateTime, default=datetime.datetime.now(), 
            onupdate=datetime.datetime.now())


class SerialNumberMixin(object):            
    """Keep a serial number."""
    @declared_attr
    def serial_number(cls):
        return Column(Integer, nullable=True, default=0)


class Object(Base, TimeStampMixin, SerialNumberMixin):
    id = Column(Integer, primary_key=True)
    class_name = Column("class_name", String(25))
    __mapper_args__ = dict(polymorphic_on=class_name)

    properties = relationship("Property")
    notes = relationship("Note")
    slug = relationship("Slug", uselist=False, backref="object")

    def __init__(self, *args, **kwargs):
        self.class_name = "Qubit%s" % self.__class__.__name__
        super(Object, self).__init__(*args, **kwargs)

    def __repr__(self):
        return "<%s: %s>" % (self.__class__, self.id)

    @declared_attr
    def __tablename__(cls):
        """Generate tablename from underscored
        version of class name"""
        return cc2us(cls.__name__)

    @declared_attr
    def __mapper_args__(cls):
        args = dict(
                polymorphic_identity="Qubit%s" % cls.__name__)
        # FIXME: Find a way around referencing this here        
        if issubclass(cls, NestedObjectMixin):
            args.update(extension=NestedSetExtension(), batch=False)
        return args


@annotate_i18n
class Taxonomy(Object, NestedObjectMixin, I18NMixin):
    """Taxonomy model."""
    id = Column(Integer, ForeignKey('object.id'), primary_key=True)
    usage = Column(String(255), nullable=True)

    # Qubit primary keys are hard-coded for these items
    ROOT_ID = 30
    DESCRIPTION_DETAIL_LEVEL_ID = 31
    ACTOR_ENTITY_TYPE_ID = 32
    DESCRIPTION_STATUS_ID = 33
    LEVEL_OF_DESCRIPTION_ID = 34
    SUBJECT_ID = 35
    ACTOR_NAME_TYPE_ID = 36
    NOTE_TYPE_ID = 37
    REPOSITORY_TYPE_ID = 38
    EVENT_TYPE_ID = 40
    QUBIT_SETTING_LABEL_ID = 41
    PLACE_ID = 42
    FUNCTION_ID = 43
    HISTORICAL_EVENT_ID = 44
    COLLECTION_TYPE_ID = 45
    MEDIA_TYPE_ID = 46
    DIGITAL_OBJECT_USAGE_ID = 47
    PHYSICAL_OBJECT_TYPE_ID = 48
    RELATION_TYPE_ID = 49
    MATERIAL_TYPE_ID = 50
    RAD_NOTE_ID = 51
    RAD_TITLE_NOTE_ID = 52
    MODS_RESOURCE_TYPE_ID = 53
    DC_TYPE_ID = 54
    ACTOR_RELATION_TYPE_ID = 55
    RELATION_NOTE_TYPE_ID = 56
    TERM_RELATION_TYPE_ID = 57
    STATUS_TYPE_ID = 59
    PUBLICATION_STATUS_ID = 60
    ISDF_RELATION_TYPE_ID = 61


@annotate_i18n
class Term(Object, NestedObjectMixin, I18NMixin):
    """Term model."""
    id = Column(Integer, ForeignKey('object.id'), primary_key=True)
    taxonomy_id = Column(Integer, ForeignKey('taxonomy.id'))
    taxonomy = relationship(Taxonomy, primaryjoin=taxonomy_id == Taxonomy.id)
    code = Column(String(255), nullable=True)

    # ROOT term id
    ROOT_ID = 110

    # Event type taxonomy
    CREATION_ID = 111
    CUSTODY_ID = 113
    PUBLICATION_ID = 114
    CONTRIBUTION_ID = 115
    COLLECTION_ID = 117
    ACCUMULATION_ID = 118

    # Note type taxonomy
    TITLE_NOTE_ID = 119
    PUBLICATION_NOTE_ID = 120
    SOURCE_NOTE_ID = 121
    SCOPE_NOTE_ID = 122
    DISPLAY_NOTE_ID = 123
    ARCHIVIST_NOTE_ID = 124
    GENERAL_NOTE_ID = 125
    OTHER_DESCRIPTIVE_DATA_ID = 126
    MAINTENANCE_NOTE_ID = 127

    # Collection type taxonomy
    ARCHIVAL_MATERIAL_ID = 128
    PUBLISHED_MATERIAL_ID = 129
    ARTEFACT_MATERIAL_ID = 130

    # Actor type taxonomy
    CORPORATE_BODY_ID = 131
    PERSON_ID = 132
    FAMILY_ID = 133

    # Other name type taxonomy
    FAMILY_NAME_FIRST_NAME_ID = 134

    # Media type taxonomy
    AUDIO_ID = 135
    IMAGE_ID = 136
    TEXT_ID = 137
    VIDEO_ID = 138
    OTHER_ID = 139

    # Digital object usage taxonomy
    MASTER_ID = 140
    REFERENCE_ID = 141
    THUMBNAIL_ID = 142
    COMPOUND_ID = 143

    # Physical object type taxonomy
    LOCATION_ID = 144
    CONTAINER_ID = 145
    ARTEFACT_ID = 146

    # Relation type taxonomy
    HAS_PHYSICAL_OBJECT_ID = 147

    # Actor name type taxonomy
    PARALLEL_FORM_OF_NAME_ID = 148
    OTHER_FORM_OF_NAME_ID = 149

    # Actor relation type taxonomy
    HIERARCHICAL_RELATION_ID = 150
    TEMPORAL_RELATION_ID = 151
    FAMILY_RELATION_ID = 152
    ASSOCIATIVE_RELATION_ID = 153

    # Actor relation note taxonomy
    RELATION_NOTE_DESCRIPTION_ID = 154
    RELATION_NOTE_DATE_ID = 155

    # Term relation taxonomy
    ALTERNATIVE_LABEL_ID = 156
    TERM_RELATION_ASSOCIATIVE_ID = 157

    # Status type taxonomy
    STATUS_TYPE_PUBLICATION_ID = 158

    # Publication status taxonomy
    PUBLICATION_STATUS_DRAFT_ID = 159
    PUBLICATION_STATUS_PUBLISHED_ID = 160

    # Name access point
    NAME_ACCESS_POINT_ID = 161

    # Function relation type taxonomy
    ISDF_HIERARCHICAL_RELATION_ID = 162
    ISDF_TEMPORAL_RELATION_ID = 163
    ISDF_ASSOCIATIVE_RELATION_ID = 164

    # ISAAR standardized form name
    STANDARDIZED_FORM_OF_NAME_ID = 165

    # External URI
    EXTERNAL_URI_ID = 166


@annotate_i18n
class InformationObject(Object, NestedObjectMixin, I18NMixin):
    id = Column(Integer, ForeignKey('object.id'), primary_key=True)
    identifier = Column(String(255))
    oai_local_identifier = Column(Integer, autoincrement=True)
    level_of_description_id = Column(Integer, ForeignKey('term.id'))
    level_of_description = relationship(Term, 
                primaryjoin="and_(InformationObject.level_of_description_id==Term.id, "
                    "Term.taxonomy_id==%s)" % Taxonomy.LEVEL_OF_DESCRIPTION_ID)

    def __repr__(self):
        return "<%s: %s> (%d, %d)" % (self.class_name, self.identifier, self.lft, self.rgt)


@annotate_i18n
class Actor(Object, NestedObjectMixin, I18NMixin):
    id = Column(Integer, ForeignKey('object.id'), primary_key=True)
    corporate_body_identifiers = Column(String(255))
    entity_type_id = Column(Integer, ForeignKey('term.id'), nullable=True)
    entity_type = relationship(Term, 
                primaryjoin="and_(Actor.entity_type_id==Term.id, "
                    "Term.taxonomy_id==%s)" % Taxonomy.ACTOR_ENTITY_TYPE_ID)
    description_status_id = Column(Integer, ForeignKey('term.id'), nullable=True)
    description_status = relationship(Term, 
                primaryjoin="and_(Actor.description_status_id==Term.id, "
                    "Term.taxonomy_id==%s)" % Taxonomy.DESCRIPTION_STATUS_ID)
    description_detail_id = Column(Integer, ForeignKey('term.id'), nullable=True)
    description_detail = relationship(Term, 
                primaryjoin="and_(Actor.description_detail_id==Term.id, "
                    "Term.taxonomy_id==%s)" % Taxonomy.DESCRIPTION_DETAIL_LEVEL_ID)
    contacts = relationship("ContactInformation")


@annotate_i18n
class Repository(Actor):
    id = Column(Integer, ForeignKey('actor.id'), primary_key=True)
    identifier = Column(String(255))
    desc_status_id = Column(Integer, ForeignKey('term.id'), nullable=True)
    desc_status = relationship(Term, 
                primaryjoin="and_(Repository.desc_status_id==Term.id, "
                    "Term.taxonomy_id==%s)" % Taxonomy.DESCRIPTION_STATUS_ID)
    desc_detail_id = Column(Integer, ForeignKey('term.id'), nullable=True)
    desc_detail = relationship(Term, 
                primaryjoin="and_(Repository.desc_detail_id==Term.id, "
                    "Term.taxonomy_id==%s)" % Taxonomy.DESCRIPTION_DETAIL_LEVEL_ID)


class User(Actor):
    id = Column(Integer, ForeignKey('actor.id'), primary_key=True)
    username = Column(String(255))
    email = Column(String(255))
    sha1_password = Column(String(255))
    salt = Column(String(255))


@annotate_i18n
class Property(Base, TimeStampMixin, SerialNumberMixin, I18NMixin):
    """Property class."""
    __tablename__ = "property"

    id = Column(Integer, primary_key=True)
    object_id = Column(Integer, ForeignKey("object.id"))
    scope = Column(String(255), nullable=True)
    name = Column(String(255))


@annotate_i18n
class Note(Base, TimeStampMixin, SerialNumberMixin, I18NMixin, NestedObjectMixin):
    """Note class."""
    __tablename__ = "note"

    id = Column(Integer, primary_key=True)
    object_id = Column(Integer, ForeignKey("object.id"))
    type_id = Column(Integer, ForeignKey("type.id"))
    scope = Column(String(255), nullable=True)
    user_id = Column(Integer, ForeignKey("user.id"))


@annotate_i18n
class ContactInformation(Base, TimeStampMixin, SerialNumberMixin, I18NMixin):
    """Contact Information class."""
    __tablename__ = "contact_information"

    id = Column(Integer, primary_key=True)
    actor_id = Column(Integer, ForeignKey("object.id"))
    primary_contact = Column(Boolean, nullable=True)
    contact_person = Column(String(255), nullable=True)
    street_address = Column(Text, nullable=True)
    website = Column(String(255), nullable=True)
    email = Column(String(255), nullable=True)
    telephone = Column(String(255), nullable=True)
    fax = Column(String(255), nullable=True)
    postal_code = Column(String(255), nullable=True)
    country_code = Column(String(255), nullable=True)
    longitude = Column(Float, nullable=True)
    latitude = Column(Float, nullable=True)


class Slug(Base, SerialNumberMixin):
    """Slug class."""
    __tablename__ = "slug"

    id = Column(Integer, primary_key=True)
    object_id = Column(Integer, ForeignKey("object.id"))
    slug = Column(String(255))

