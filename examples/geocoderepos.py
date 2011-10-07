"""
Set lat-long fields on Contact objects.
"""

from optparse import OptionParser
import phpserialize
import unicodedata
import urllib
import httplib2
import json

from incf.countryutils import data as countrydata

from sqlaqubit import models, keys, create_engine, init_models
from sqlalchemy.engine.url import URL


HELP = """Set lat/long fields on Repository addresses."""


def get_options():
    """Parse command-line args."""
    parser = OptionParser(
            usage="usage: %prog [options]", version="%prog 1.0")
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
            "-m",
            "--max",
            type="int",
            action="store",
            dest="max",
            default=-1,
            help="Number of geocodes to run")
    parser.add_option(
            "--dump",
            action="store_true",
            dest="dump",
            help="Dump info to stdout only, without updating database")
    parser.add_option(
            "-o",
            "--overwrite",
            action="store_true",
            dest="overwrite",
            help="Overwrite existing lat/long info")
    return parser.parse_args()


def get_country_from_code(code):
    """Get the country code from a coutry name."""
    ccn = countrydata.cca2_to_ccn.get(code)
    if ccn is None:
        return
    return countrydata.ccn_to_cn.get(ccn)



class ContactGeocoder(object):
    def __init__(self):

        self.options, self.args = get_options()

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


    def geocode_addresses(self):
        """Process file."""
        
        query = self.session.query(models.ContactInformation)
        if self.options.max > 0:
            query = query.limit(self.options.max)

        for contact in query.all():
            self.geocode(contact)

        self.session.commit()


    def geocode(self, contact):
        """Geocode individual addresses."""


        if not self.options.overwrite and contact.latitude:
            return False

        address = contact.street_address
        country = get_country_from_code(contact.country_code)
        if country is not None:
            address = "%s %s" % (address, country)

        print "\n\nGeocoding address %d" % contact.id
        for line in address.split("\n"):
            print " - %s" % line

        data = dict(address=address, sensor="false")
        body = urllib.urlencode(data)
        h = httplib2.Http()
        resp, content = h.request(
                "http://maps.googleapis.com/maps/api/geocode/json?" + body)

        if resp["status"] != "200":
            print "Unexpected status %s from address: %s" % (
                    resp["status"], address)
            return False

        try:
            geodata = json.loads(content)
        except ValueError:
            print "Error parsing JSON data"
            return False

        if geodata["status"] == "ZERO_RESULTS":
            print "No results found"
            return False

        if geodata["status"] == "OVER_QUERY_LIMIT":
            print "Over query limit"
            return False

        results = geodata["results"][0]
        print "Result type: %s" % results["geometry"]["location_type"]

        # if we get an exact location, update the street address
        # and postcode with the Google-formatted one
        if results["geometry"]["location_type"] in ["APPROXIMATE", "ROOFTOP", 
                "RANGE_INTERPOLATED", "GEOMETRIC_CENTER"]:
            contact.latitude  = results["geometry"]["location"]["lat"]
            contact.longitude = results["geometry"]["location"]["lng"]
            for component in results["address_components"]:
                if "postal_code" in component["types"]:
                    contact.postal_code = component["long_name"]
            if "street_address" in results["types"]:                    
                contact.street_address = results["formatted_address"]
                print "Updated formatted address: %s" % contact.street_address
        return True                


if __name__ == "__main__":
    g = ContactGeocoder()
    g.geocode_addresses()


