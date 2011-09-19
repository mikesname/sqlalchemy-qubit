"""
SQLAlchemy model of the Qubit Toolkit database.
"""

import re
import datetime

from sqlalchemy import (
            Column, String, Integer, Float, Boolean, Text, 
            DateTime, ForeignKey, ForeignKeyConstraint,
            select, case, func, Table)
from sqlalchemy.ext.declarative import declarative_base, declared_attr
from sqlalchemy.orm import sessionmaker, MapperExtension, relationship, backref, mapper
from sqlalchemy.orm.exc import NoResultFound
from sqlalchemy.sql import and_, or_, not_

from keys import TaxonomyKeys, TermKeys


Base = declarative_base()
Session = sessionmaker()


def init_i18n_class(cls):
    """Create, via metadata reflection, an I18N class object
    for i18n-enabled tables."""
    tablename = cls.__tablename__ + "_i18n"
    if Base.metadata.tables.get(tablename) is not None: 
        classname = cls.__name__ + "I18N"
        i18nt = Table(tablename, Base.metadata, 
                Column("id", ForeignKey("%s.id" % cls.__tablename__), primary_key=True),
                Column("culture", String(25), primary_key=True),
                ForeignKeyConstraint(["id"], ["%s.id" % cls.__tablename__]),
                autoload=True, extend_existing=True)
        globals()[classname] =type(classname, (Base,), dict(__table__=i18nt))
        setattr(cls, tablename, relationship(classname, cascade="all,delete-orphan",
                primaryjoin="%s.id == %s.id" % (classname, cls.__name__)))

def unregister_i18n():
    """Remove i18n tables from the class registry.
    FIXME: There should be a better way of doing this."""
    delete = []
    for name, cls in Base._decl_class_registry.iteritems():
        if name.endswith("I18N"):
            delete.append(name)
    for name in delete:
        del Base._decl_class_registry[name]


def cc2us(name):
    """Convert CamelCase to under_score."""
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()


class NestedSetExtension(MapperExtension):
    """Mapper extension to update table nested set records
    when an object is created, updated, or deleted."""
    def before_insert(self, mapper, connection, instance):
        if instance.lft and instance.rgt:
            return

        table = instance.nested_object_table()
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
        """Updated nested tree values."""
        table = instance.nested_object_table()
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
        table = instance.nested_object_table()
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
                primaryjoin=("%s.id==%s.parent_id" % (cls.__name__, cls.__name__)),
                enable_typechecks=False)

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
    """Mixin class for objects that have an associated i18n table."""

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
        except NoResultFound:
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
    def _set_class_i18n(cls, session, klass, object, lang, data):
        """Set the I18N data for a given class, object id, and lang."""
        try:
            i18ncls = globals()[klass.__name__ + "I18N"]
        except KeyError:
            return
        try:
            i18n = session.query(i18ncls).filter(
                    and_(i18ncls.id==object.id, i18ncls.culture==lang)).one()
        except NoResultFound:
            i18n = i18ncls(id=object.id, culture=lang)
            attrname = "%s_i18n" % klass.__tablename__
            getattr(object, attrname).append(i18n)
        for col, spec in dict(i18ncls.__table__.columns).iteritems():
            if spec.primary_key:
                continue
            if data.get(col):
                setattr(i18n, col, data.get(col))

    @classmethod
    def _set_i18n(cls, session, object, lang, data):
        """Set the i18n data for a given class AND it's
        base classes."""
        for baseclass in cls.__bases__:
            if hasattr(baseclass, "_set_i18n"):
                baseclass._set_i18n(session, object, lang, data)
        cls._set_class_i18n(session, cls, object, lang, data)

    def set_i18n(self, data, lang="en"):
        """Set i18n data for a given object."""
        session = Session.object_session(self)
        if not self in session:
            session.add(self)
        self._set_i18n(session, self, lang, data)


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
    """Keep a serial number (currently defaults to 0)."""
    @declared_attr
    def serial_number(cls):
        return Column(Integer, nullable=True, default=0)


class Object(Base, TimeStampMixin, SerialNumberMixin):
    """Qubit Object base class."""
    id = Column(Integer, primary_key=True)
    class_name = Column("class_name", String(25))
    __mapper_args__ = dict(polymorphic_on=class_name)

    def __init__(self, *args, **kwargs):
        """Set class_name on creation."""
        self.class_name = "Qubit%s" % self.__class__.__name__
        super(Object, self).__init__(*args, **kwargs)

    def __repr__(self):
        return "<%s: %s>" % (self.__class__.__name__, self.id)

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


class Taxonomy(Object, NestedObjectMixin, I18NMixin):
    """Taxonomy model."""
    id = Column(Integer, ForeignKey('object.id'), primary_key=True)
    usage = Column(String(255), nullable=True)


class Term(Object, NestedObjectMixin, I18NMixin):
    """Term model."""
    id = Column(Integer, ForeignKey('object.id'), primary_key=True)
    taxonomy_id = Column(Integer, ForeignKey('taxonomy.id'))
    taxonomy = relationship(Taxonomy, primaryjoin=taxonomy_id == Taxonomy.id)
    code = Column(String(255), nullable=True)


class InformationObject(Object, NestedObjectMixin, I18NMixin):
    id = Column(Integer, ForeignKey('object.id'), primary_key=True)
    identifier = Column(String(255))
    oai_local_identifier = Column(Integer, autoincrement=True)
    level_of_description_id = Column(Integer, ForeignKey('term.id'))
    level_of_description = relationship(Term, 
                primaryjoin="and_(InformationObject.level_of_description_id==Term.id, "
                    "Term.taxonomy_id==%s)" % TaxonomyKeys.LEVEL_OF_DESCRIPTION_ID)

    def __repr__(self):
        return "<%s: %s> (%d, %d)" % (self.class_name, self.identifier, self.lft, self.rgt)


class Actor(Object, NestedObjectMixin, I18NMixin):
    id = Column(Integer, ForeignKey('object.id'), primary_key=True)
    corporate_body_identifiers = Column(String(255))
    entity_type_id = Column(Integer, ForeignKey('term.id'), nullable=True)
    entity_type = relationship(Term, 
                primaryjoin="and_(Actor.entity_type_id==Term.id, "
                    "Term.taxonomy_id==%s)" % TaxonomyKeys.ACTOR_ENTITY_TYPE_ID)
    description_status_id = Column(Integer, ForeignKey('term.id'), nullable=True)
    description_status = relationship(Term, 
                primaryjoin="and_(Actor.description_status_id==Term.id, "
                    "Term.taxonomy_id==%s)" % TaxonomyKeys.DESCRIPTION_STATUS_ID)
    description_detail_id = Column(Integer, ForeignKey('term.id'), nullable=True)
    description_detail = relationship(Term, 
                primaryjoin="and_(Actor.description_detail_id==Term.id, "
                    "Term.taxonomy_id==%s)" % TaxonomyKeys.DESCRIPTION_DETAIL_LEVEL_ID)


class Repository(Actor):
    id = Column(Integer, ForeignKey('actor.id'), primary_key=True)
    identifier = Column(String(255))
    desc_status_id = Column(Integer, ForeignKey('term.id'), nullable=True)
    desc_status = relationship(Term, 
                primaryjoin="and_(Repository.desc_status_id==Term.id, "
                    "Term.taxonomy_id==%s)" % TaxonomyKeys.DESCRIPTION_STATUS_ID)
    desc_detail_id = Column(Integer, ForeignKey('term.id'), nullable=True)
    desc_detail = relationship(Term, 
                primaryjoin="and_(Repository.desc_detail_id==Term.id, "
                    "Term.taxonomy_id==%s)" % TaxonomyKeys.DESCRIPTION_DETAIL_LEVEL_ID)
    source_culture = Column(String(7))


class User(Actor):
    id = Column(Integer, ForeignKey('actor.id'), primary_key=True)
    username = Column(String(255))
    email = Column(String(255))
    sha1_password = Column(String(255))
    salt = Column(String(255))

    def __repr__(self):
        return "<%s: %s>" % (self.username, self.id)

class Property(Base, TimeStampMixin, SerialNumberMixin, I18NMixin):
    """Property class."""
    __tablename__ = "property"

    id = Column(Integer, primary_key=True)
    object_id = Column(Integer, ForeignKey("object.id"))
    object = relationship(Object, backref="properties", enable_typechecks=False)
    scope = Column(String(255), nullable=True)
    name = Column(String(255))


class Note(Base, NestedObjectMixin, TimeStampMixin, SerialNumberMixin, I18NMixin):
    """Note class."""
    __tablename__ = "note"
    __mapper_args__ = dict(extension=NestedSetExtension(), batch=False)

    id = Column(Integer, primary_key=True)
    object_id = Column(Integer, ForeignKey("object.id"))
    object = relationship(Object, backref="notes", enable_typechecks=False)
    type_id = Column(Integer, ForeignKey("term.id"))
    type = relationship(Term,
                primaryjoin="and_(Note.type_id==Term.id, "
                    "Term.taxonomy_id==%s)" % TaxonomyKeys.NOTE_TYPE_ID)
    scope = Column(String(255), nullable=True)
    user_id = Column(Integer, ForeignKey("user.id"))
    user = relationship(Actor, backref="user_notes", enable_typechecks=False)


class ContactInformation(Base, TimeStampMixin, SerialNumberMixin, I18NMixin):
    """Contact Information class."""
    __tablename__ = "contact_information"

    id = Column(Integer, primary_key=True)
    actor_id = Column(Integer, ForeignKey("object.id"))
    actor = relationship(Actor, backref="contacts", enable_typechecks=False)
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
    object = relationship(Object, backref="slug", uselist=False, enable_typechecks=False)
    slug = Column(String(255))


class OtherName(Base, TimeStampMixin, SerialNumberMixin, I18NMixin):
    """Other Name class."""
    __tablename__ = "other_name"

    id = Column(Integer, primary_key=True)
    object_id = Column(Integer, ForeignKey("object.id"))
    object = relationship(Object, backref="other_names", enable_typechecks=False)
    type_id = Column(Integer, ForeignKey("term.id"))
    type = relationship(Term,
                primaryjoin="and_(OtherName.type_id==Term.id, "
                    "Term.taxonomy_id==%s)" % TaxonomyKeys.ACTOR_NAME_TYPE_ID)

