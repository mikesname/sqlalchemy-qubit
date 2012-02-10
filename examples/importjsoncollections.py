"""
Import collections to a specific repo, using a JSON file as input.
"""

import re
from optparse import OptionParser
import phpserialize
import unicodedata
import urllib
import httplib2
import json
import datetime

from incf.countryutils import data as countrydata

from sqlaqubit import models, keys, create_engine, init_models
from sqlalchemy.engine.url import URL
from sqlalchemy.orm.exc import NoResultFound


FIELDS = [
    "refcode",
    "held_at",
    "full_title",
    "dates",
    "lod",
    "extent",
    "name_of_creators",
    "admin_biog_hist",
    "scope_content",
    "arrangement",
    "access_cond",
    "reprod_cond",
    "finding_aids",
    "source_of_acquisition",
    "language",
    "archivist_note",
    "rules_conventions",
    "dates_of_description",
    "related_materials",
    "publication_note",
]


SLUGIFY_STRIP_RE = re.compile(r'[^\w\s-]')
SLUGIFY_HYPHENATE_RE = re.compile(r'[-\s]+')
def slugify(value):
    """
    Normalizes string, converts to lowercase, removes non-alpha characters,
    and converts spaces to hyphens.

    From Django's "django/template/defaultfilters.py".
    """
    if not isinstance(value, unicode):
        value = unicode(value)
    value = unicodedata.normalize('NFKD', value).encode('ascii', 'ignore')
    value = unicode(SLUGIFY_STRIP_RE.sub('', value).strip().lower())
    return SLUGIFY_HYPHENATE_RE.sub('-', value)


class CollectionImport(object):
    def __init__(self):
        """Initialise importer."""
        parser = OptionParser(usage="usage: %prog [options] <repository_name> <jsonfile>",
                              version="%prog 1.0")
        parser.add_option(
                "-f",
                "--from",
                action="store",
                dest="fromrec",
                type="int",
                default=1,
                help="Import records from this offset")
        parser.add_option(
                "-t",
                "--to",
                action="store",
                dest="to",
                type="int",
                default=-1,
                help="Import records up to this offset")
        parser.add_option(
                "-U",
                "--dbuser",
                action="store",
                dest="dbuser",
                default="qubit",
                help="Database user")
        parser.add_option(
                "-p",
                "--dbpass",
                action="store",
                dest="dbpass",
                help="Database password")
        parser.add_option(
                "-H",
                "--dbhost",
                action="store",
                dest="dbhost",
                default="localhost",
                help="Database host name")
        parser.add_option(
                "-P",
                "--dbport",
                action="store",
                dest="dbport",
                help="Database host name")
        parser.add_option(
                "-D",
                "--database",
                action="store",
                dest="database",
                default="qubit",
                help="Database name")
        parser.add_option(
                "-u",
                "--user",
                action="store",
                dest="user",
                default="qubit",
                help="User to own imported records")
        parser.add_option(
                "-l",
                "--lang",
                action="store",
                dest="lang",
                default="en",
                help="Language for imported i18n fields")

        self.options, self.args = parser.parse_args()
        if len(self.args) != 2:
            parser.error()
        self.reponame = self.args[0]
        self.jsonfile = self.args[1]

        engine = create_engine(URL("mysql",
            username=self.options.dbuser,
            password=self.options.dbpass,
            host=self.options.dbhost,
            database=self.options.database,
            port=self.options.dbport,
            query=dict(
                charset="utf8", 
                use_unicode=0
            )
        ))
        init_models(engine)
        self.session = models.Session()
        try:
            self.repo = self.session.query(models.Repository)\
                    .join(models.ActorI18N, models.ActorI18N.id == models.Repository.id)\
                    .filter(models.ActorI18N.authorized_form_of_name==self.reponame)\
                    .one()
        except NoResultFound:
            print >> sys.stderr, "No repository found for name: %s" % self.reponame
            sys.exit(1)
        try:
            self.user = self.session.query(models.User).filter(
                    models.User.username == self.options.user).one()
        except NoResultFound:
            print >> sys.stderr, "No user found for name: %s" % self.options.user
            sys.exit(1)
        self.parent = self.session.query(models.InformationObject)\
                .filter(models.InformationObject.id==keys.InformationObjectKeys.ROOT_ID)\
                .one()
        # load default status and detail... this is where
        # SQLAlchemy gets horrible
        self.status = self.session.query(models.Term)\
                .filter(models.Term.taxonomy_id == keys.TaxonomyKeys\
                    .DESCRIPTION_STATUS_ID)\
                .join(models.TermI18N, models.Term.id == models.TermI18N.id)\
                .filter(models.TermI18N.name == "Draft").one()
        self.detail = self.session.query(models.Term)\
                .filter(models.Term.taxonomy_id == keys.TaxonomyKeys\
                    .DESCRIPTION_DETAIL_LEVEL_ID)\
                .join(models.TermI18N, models.Term.id == models.TermI18N.id)\
                .filter(models.TermI18N.name == "Partial").one()
        self.pubtype = self.session.query(models.Term)\
                .filter(models.Term.taxonomy_id == keys.TaxonomyKeys\
                    .STATUS_TYPE_ID)\
                .join(models.TermI18N, models.Term.id == models.TermI18N.id)\
                .filter(models.TermI18N.name == "publication").one()
        self.pubstatus = self.session.query(models.Term)\
                .filter(models.Term.taxonomy_id == keys.TaxonomyKeys\
                    .PUBLICATION_STATUS_ID)\
                .join(models.TermI18N, models.Term.id == models.TermI18N.id)\
                .filter(models.TermI18N.name == "published").one()
        self.lod_fonds = self.session.query(models.Term)\
                .filter(models.Term.taxonomy_id == keys.TaxonomyKeys\
                    .LEVEL_OF_DESCRIPTION_ID)\
                .join(models.TermI18N, models.Term.id == models.TermI18N.id)\
                .filter(models.TermI18N.name == "Fonds").one() 
        self.lod_coll = self.session.query(models.Term)\
                .filter(models.Term.taxonomy_id == keys.TaxonomyKeys\
                    .LEVEL_OF_DESCRIPTION_ID)\
                .join(models.TermI18N, models.Term.id == models.TermI18N.id)\
                .filter(models.TermI18N.name == "Collection").one()
        self.slugs = {}

    def import_data(self):
        """Process file."""

        options = self.options

        records = None
        with open(self.jsonfile, "r") as jh:
            records = json.load(jh)
        count = 0
        for record in records:
            count += 1
            if options.fromrec > 0 and count < options.fromrec:
                continue
            print "Adding %d: %s\n" % (count, record["full_title"])
            self.handle_row(
                    record,
                    count,
                    options.lang
            )
            if options.to > 0 and count == options.to:
                break
        print "Flushing transaction..."
        self.session.commit()
        print "Done"

    def parse_date(self, datestr, info, lang):
        """Parse dates like "1939-1946", "c 1945" etc"""
        m1 = re.search("^(\d{4})-(\d{4})$", datestr.strip())
        if m1:
            d1 = datetime.date(int(m1.group(1)), 1, 1)
            d2 = datetime.date(int(m1.group(2)), 12, 31)
            event = models.Event(start_date=str(d1), end_date=str(d2),
                    type_id=keys.TermKeys.CREATION_ID, information_object_id=info.id,
                    source_culture=lang)
            return event
        m2 = re.search("^c (\d{4})$", datestr.strip())
        if m2:
            d1 = datetime.date(int(m2.group(1)), 1, 1)
            return models.Event(start_date=d1,
                    type_id=keys.TermKeys.CREATION_ID, information_object=info,
                    source_culture=lang)


    def handle_row(self, record, count, lang):
        """Import a collection dictionary."""
        
        lod = self.lod_fonds if "fonds" in record["lod"].lower() \
                else self.lod_coll

        info = models.InformationObject(
            identifier=record["refcode"],
            source_culture=lang,
            parent=self.parent,
            repository=self.repo,
            level_of_description=lod,
            description_status_id=self.status.id,
            description_detail_id=self.detail.id,
            source_standard="ISAD(G) 2nd Edition"
        )
        self.session.add(info)
        revision = "%s: Imported from AIM25" % datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        info.set_i18n(dict(
            title=record["full_title"],
            extent_and_medium=record["extent"],
            acquisition=record["source_of_acquisition"],
            arrangement=record["arrangement"],
            access_conditions=record["access_cond"],
            reproduction_conditions=record["reprod_cond"],
            scope_and_content=record["scope_content"],
            finding_aids=record["finding_aids"],
            location_of_copies=record["held_at"],
            rules=record["rules_conventions"],
            revision_history=record["admin_biog_hist"]
        ), lang)

        info.slug.append(models.Slug(
            slug=self.unique_slug(models.Slug, record["full_title"]) 
        ))

        if record["archivist_note"].strip():
            comment = models.Note(
                    type_id=keys.TermKeys.ARCHIVIST_NOTE_ID,
                    user=self.user,
                    source_culture=lang,
                    scope="InformationObject"
            )
            info.notes.append(comment)
            comment.set_i18n(dict(
                    content=record["archivist_note"],
            ), lang)

        if record["publication_note"].strip():
            extra = models.Note(
                    type_id=keys.TermKeys.PUBLICATION_NOTE_ID,
                    user=self.user,
                    source_culture=lang,
                    scope="InformationObject"
            )
            info.notes.append(extra)
            extra.set_i18n(dict(
                    content=record["publication_note"],
            ), lang)

        event = self.parse_date(record["dates"], info, lang)
        if event:
            info.events.append(event)

        status = models.Status(object=info, 
                type_id=self.pubtype.id, status_id=self.pubstatus.id)
        self.session.add(status)

        languages = self.get_languages(record["language"])        
        langprop = models.Property(name="language", source_culture=lang)
        info.properties.append(langprop)
        langprop.set_i18n(dict(value=phpserialize.dumps([lang])), lang)
        scriptprop = models.Property(name="script", source_culture=lang)
        info.properties.append(scriptprop)
        scriptprop.set_i18n(dict(value=phpserialize.dumps(["Latn"])), lang)
        langdescprop = models.Property(name="languageOfDescription", source_culture=lang)
        info.properties.append(langdescprop)
        langdescprop.set_i18n(dict(value=phpserialize.dumps([lang])), lang)
        scriptdescprop = models.Property(name="scriptOfDescription", source_culture=lang)
        info.properties.append(scriptdescprop)
        scriptdescprop.set_i18n(dict(value=phpserialize.dumps(["Latn"])), lang)


    def get_languages(self, langstr):
        """Get short lang names as array."""
        langs = []
        if "german" in langstr.lower():
            langs.append("de")
        if "english" in langstr.lower():
            langs.append("en")
        if "french" in langstr.lower():
            langs.append("fr")
        return langs

    def unique_slug(self, model, value):
        """Get a slug not currently used in the DB."""
        suffix = 0
        potential = base = slugify(value)
        while True:
            if suffix:
                potential = "-".join([base, str(suffix)])
            if not self.session.query(model).filter(model.slug == potential).count()\
                    and self.slugs.get(potential) is None:
                self.slugs[potential] = True
                return potential
            # we hit a conflicting slug, so bump the suffix & try again
            suffix += 1


if __name__ == "__main__":
    CollectionImport().import_data()





