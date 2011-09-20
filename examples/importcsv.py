"""
Import a CSV file into the Qubit Database.

The fields we're expecting are:

   Address
   City
   Contact
   Country
   E-mail
   English Name
   Extra
   Fax
   Origin
   Original Name
   Phone
   Source
   State
   Survey 1
   URL
"""

import re
import datetime
import csv
from optparse import OptionParser
import phpserialize
import unicodedata

from incf.countryutils import data as countrydata

from sqlaqubit import models, keys, create_engine, init_models
from sqlalchemy.engine.url import URL


HELP = """Import CSV files into the database."""


class CvsImportError(StandardError):
    """Something went wrong."""
    pass

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


def get_country_code(name):
    """Get the country code from a coutry name."""
    ccn = countrydata.cn_to_ccn.get(name)
    if ccn is None:
        return
    return countrydata.ccn_to_cca2.get(ccn)


def get_address(record):
    """Create a consolidated form of address, including state."""
    address = record["Address"]
    if record["State"].strip():
        address += "\n%s" % record["State"]
    return address


def cleanup_data(rawrecord):
    """Ensure values are unicode, stripped of whitespace."""
    record = {}
    for key, value in rawrecord.iteritems():
        if isinstance(value, str):
            record[key] = unicode(value, encoding="utf8").strip()
        else:
            record[key] = unicode("", encoding="utf8")
    return record


class CsvImporter(object):
    """Import a CSV file in a specific format."""

    def __init__(self):
        """Initialise importer."""
        parser = OptionParser(usage="usage: %prog [options] <csvfile>",
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
        if len(self.args) != 1:
            parser.error("No CSV file provided")

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

        self.user = self.session.query(models.User).filter(
                models.User.username == self.options.user).one()
        self.parent = self.session.query(models.Actor)\
                .filter(models.Actor.id==keys.ActorKeys.ROOT_ID).one()
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

        # running count of slugs used so far in the import transaction
        self.slugs = {}


    def import_data(self):
        """Process file."""

        csvfile = self.args[0]
        options = self.options

        # attempt to sniff the CSV dialect
        handle = open(csvfile, "rb")
        sample = handle.read(1024)
        handle.seek(0)
        dialect = csv.Sniffer().sniff(sample)

        # the first line MUST be headers
        reader = csv.DictReader(handle, dialect=dialect)
        for record in reader:
            if options.fromrec > 0 and reader.line_num < options.fromrec:
                continue
            print "Adding %d: %s\n" % (reader.line_num, record["Original Name"])
            self.handle_row(
                    cleanup_data(record),
                    reader.line_num,
                    options.lang
            )
            if options.to > 0 and reader.line_num == options.to:
                break
        print "Flushing transaction..."
        self.session.commit()
        print "Done"


    def handle_row(self, record, index, lang):
        """Import a row of data."""

        countrycode = get_country_code(record["Country"])
        truncname = record["Original Name"][0:255]
        if truncname == "" and record["English Name"] != "":
            truncname = record["English Name"]

        repo = models.Repository(
            identifier="ehri%d%s" % (index, countrycode),
            entity_type_id=keys.TermKeys.CORPORATE_BODY_ID,
            source_culture=lang,
            parent=self.parent,
            description_status=self.status,
            description_detail=self.detail,
            desc_status=self.status,
            desc_detail=self.detail
        )
        self.session.add(repo)
        revision = "%s: Imported from EHRI spreadsheet" % datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        repo.set_i18n(dict(
            authorized_form_of_name=truncname,
            desc_sources=record["Origin"],
            desc_rules="ISDIAH",
            desc_revision_history=revision
        ), lang)

        repo.slug.append(models.Slug(
            slug=self.unique_slug(models.Slug, truncname) 
        ))

        if record["Comments"]:
            comment = models.Note(
                    type_id=keys.TermKeys.MAINTENANCE_NOTE_ID,
                    user=self.user,
                    source_culture=lang,
                    scope="QubitRepository"
            )
            repo.notes.append(comment)
            comment.set_i18n(dict(
                    content=record["Comments"],
            ), lang)

        if record["Extra"]:
            extra = models.Note(
                    type_id=keys.TermKeys.MAINTENANCE_NOTE_ID,
                    user=self.user,
                    source_culture=lang,
                    scope="QubitRepository"
            )
            repo.notes.append(extra)
            extra.set_i18n(dict(
                    content=record["Extra"],
            ), lang)

        if record["English Name"] and record["English Name"][0:255] != truncname:
            othername = models.OtherName(
                    type_id=keys.TermKeys.PARALLEL_FORM_OF_NAME_ID,
                    source_culture=lang
            )
            repo.other_names.append(othername)
            othername.set_i18n(dict(
                name=record["English Name"][0:255]
            ), lang)

        contact = models.ContactInformation(
            source_culture=lang,
            primary_contact=True,
            contact_person=record["Contact"],
            country_code=countrycode,
            email=record["E-mail"],
            website=record["URL"],
            street_address=get_address(record),
            fax=record["Fax"],
            telephone=record["Phone"]
        )
        repo.contacts.append(contact)
        contact.set_i18n(dict(
                contact_type="Main",
                city=record["City"],
                region=record["State"],
                note="Import from EHRI contact spreadsheet"
        ), lang)

        langprop = models.Property(name="language", source_culture=lang)
        repo.properties.append(langprop)
        langprop.set_i18n(dict(value=phpserialize.dumps([lang])), lang)
        scriptprop = models.Property(name="script", source_culture=lang)
        repo.properties.append(scriptprop)
        scriptprop.set_i18n(dict(value=phpserialize.dumps(["Latn"])), lang)


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
    CsvImporter().import_data()
