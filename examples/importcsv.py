"""
Import a CSV file into the Qubit Database.
"""

import os
import sys
import re

import csv
from optparse import OptionParser, make_option
import phpserialize
import exceptions

from incf.countryutils import data as countrydata

from sqlaqubit import models

HELP = """Import CSV files into the database.""" 


class CvsImportError(StandardError):
    pass

_slugify_strip_re = re.compile(r'[^\w\s-]')
_slugify_hyphenate_re = re.compile(r'[-\s]+')
def slugify(value):
    """
    Normalizes string, converts to lowercase, removes non-alpha characters,
    and converts spaces to hyphens.
    
    From Django's "django/template/defaultfilters.py".
    """
    import unicodedata
    if not isinstance(value, unicode):
        value = unicode(value)
    value = unicodedata.normalize('NFKD', value).encode('ascii', 'ignore')
    value = unicode(_slugify_strip_re.sub('', value).strip().lower())
    return _slugify_hyphenate_re.sub('-', value)



class CsvImporter(object):

    def go(self, csvfile, options):

        # attempt to sniff the CSV dialect
        handle = open(csvfile, "rb")
        sample = handle.read(1024)
        handle.seek(0)        
        dialect = csv.Sniffer().sniff(sample)

        session = models.Session()

        user = session.query(models.User).filter(
                models.User.username == "michaelb").one()
        status = session.query(models.Term).filter(
                models.Term.taxonomy_id == models.Taxonomy.DESCRIPTION_STATUS_ID).first()
        detail = session.query(models.Term).filter(
                models.Term.taxonomy_id == models.Taxonomy.DESCRIPTION_DETAIL_LEVEL_ID).first()

        # the first line MUST be headers
        reader = csv.DictReader(handle, dialect=dialect)
        for record in reader:
            if options.fromrec > 0 and reader.line_num < options.fromrec:
                continue
            print "Adding %d: %s\n" % (reader.line_num, record["Original Name"])
            self.handle_row(session, record, reader.line_num, options.lang, user, status, detail)
            if options.to > 0 and reader.line_num == options.to:
                break
        print "Flushing transaction..."
        session.commit()
        print "Done"


    def handle_row(self, session, rawrecord, index, lang, user, status, detail):
        # fields are:
        #   Address
        #   City
        #   Contact
        #   Country        
        #   E-mail
        #   English Name
        #   Extra
        #   Fax
        #   Origin
        #   Original Name
        #   Phone
        #   Source
        #   State
        #   Survey 1
        #   URL

        record = {}
        for k, v in rawrecord.iteritems():
            if isinstance(v, str):
                record[k] = unicode(v, encoding="utf8").strip()
            else:
                record[k] = unicode("", encoding="utf8")


        countrycode = self._get_country_code(record)
        ident = "ehri%d%s" % (index, countrycode)
        truncname = record["Original Name"][0:255]
        if truncname == "" and record["English Name"] != "":
            truncname = record["English Name"]

        repo = models.Repository(
            identifier=ident,
            entity_type_id=models.Term.CORPORATE_BODY_ID,
            source_culture=lang,
            parent_id=models.Actor.ROOT_ID,
            description_status=status,
            description_detail=detail,
            desc_status=status,
            desc_detail=detail
        )
        session.add(repo)
        #session.flush()
        repo.set_i18n(dict(
            authorized_form_of_name=truncname,
            desc_sources=record["Origin"]
        ), lang)

        repo.slug = models.Slug(
            slug=self.unique_slug(session, models.Slug, truncname)
        )

        if record["Comments"]:
            comment = models.Note(
                    type_id=models.Term.MAINTENANCE_NOTE_ID,
                    user=user,
                    source_culture=lang,
                    scope="QubitRepository"
            )
            repo.notes.append(comment)
            #session.flush()
            comment.set_i18n(dict(
                    content=record["Comments"],
            ), lang)

        if record["Extra"]:
            extra = models.Note(
                    type_id=models.Term.MAINTENANCE_NOTE_ID,
                    user=user,
                    source_culture=lang,
                    scope="QubitRepository"
            )
            repo.notes.append(extra)
            extra.set_i18n(dict(
                    content=record["Extra"],
            ), lang)

        if record["English Name"] and record["English Name"] != truncname:
            othername = models.OtherName(
                    type_id=models.Term.OTHER_FORM_OF_NAME_ID,
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
            street_address=self._get_address(record),
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



    def _get_country_code(self, record):
        ccn = countrydata.cn_to_ccn.get(record["Country"].strip())
        if ccn is None:
            return
        return countrydata.ccn_to_cca2.get(ccn)

    def _get_address(self, record):
        address = record["Address"]
        if record["State"].strip():
            address += "\n%s" % record["State"]
        return address

    def unique_slug(self, session, model, value, slugfield="slug"):
        suffix = 0
        potential = base = slugify(value)
        while True:
            if suffix:
                potential = "-".join([base, str(suffix)])
            if not session.query(model).filter(model.slug == value).count():
                return potential
            # we hit a conflicting slug, so bump the suffix & try again
            suffix += 1


if __name__ == "__main__":
    help = HELP
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
            "-l",
            "--lang",
            action="store",
            dest="lang",
            default="en",
            help="Language for imported i18n fields")

    options, args = parser.parse_args()
    if len(args) != 1:
        parser.error("No CSV file provided")

    importer = CsvImporter()
    importer.go(args[0], options)
