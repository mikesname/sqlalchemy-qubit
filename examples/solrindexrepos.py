"""
Post Repos to a Solr engine.
"""

from optparse import OptionParser
import unicodedata
import urllib
import httplib2
import json

from sqlaqubit import models, keys, create_engine, init_models
from sqlalchemy.engine.url import URL
from sqlalchemy import and_


HELP = """Post Repositories to a Solr index"""

REPO_INDEX_VALUES = {
        "identifier"    : "id",
}

REPO_INDEX_I18N_VALUES = {
    "authorized_form_of_name"   : "name",
    "history"                   : "history",
    "places"                    : "places",
    "holdings"                  : "holdings",
    "buildings"                 : "buildings",
    "finding_aids"              : "finding_aids",
    "research_services"         : "research_services",
    "public_facilities"         : "public_facilities",
}

CONTACT_INDEX_VALUES = {
    "contact_person"    : "contact",
    "street_address"    : "address",
    "website"           : "website",
    "postal_code"       : "postcode",
}        

CONTACT_INDEX_I18N_VALUES = {
    "city"      : "city",
    "region"    : "region",
}        


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
            "--solrhost",
            action="store",
            dest="solrhost",
            default="localhost",
            help="Solr host")
    parser.add_option(
            "--solrport",
            action="store",
            type="int",
            dest="solrport",
            default=8983,
            help="Solr port")
    parser.add_option(
            "--solrcontent",
            action="store",
            dest="solrcontext",
            default="solr",
            help="Solr context")
    parser.add_option(
            "--batchsize",
            action="store",
            type="int",
            dest="batchsize",
            default=100,
            help="Batch size")
    return parser.parse_args()


def get_country_from_code(code):
    """Get the country code from a coutry name."""
    ccn = countrydata.cca2_to_ccn.get(code)
    if ccn is None:
        return
    return countrydata.ccn_to_cn.get(ccn)



class IndexRepos(object):
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

        self.solrurl = "http://%s:%d/%s/update/json" % (
                self.options.solrhost,
                self.options.solrport,
                self.options.solrcontext,
        )



    def index(self):
        """Do stuff"""
        
        query = self.session.query(models.Repository)
        if self.options.max > 0:
            query = query.limit(self.options.max)

        repos = query.all()
        print "Indexing %d repos" % len(repos)
        total = 0
        data = []
        for repo in repos:
            total += 1
            if not repo.identifier:
                print "\n\nCannot index repository with no identifier"
                continue
            print "\n\nIndexing repo: %s" % repo.identifier
            data.append(self.get_solr_data(repo))
            if len(data) == self.options.batchsize or total == len(repos): 
                self.index_batch(data)
                data = []


    def get_solr_data(self, repo):
        """Get a dictionary of Solr-appropriate values from the object/dict.
        Qubit fields -> Solr fields are mapped above."""
        
        data = dict(
                id=repo.identifier,
                type="repository",
        )

        def get_useful_value(thing, key, solrkey):
            value = None
            if isinstance(thing, dict):
                value = thing.get(key)
            else:
                value = getattr(thing, key)
            if value:
                data[solrkey] = value

        i18n = repo.get_i18n("en")        
        for key, solrkey in REPO_INDEX_VALUES.iteritems():
            get_useful_value(repo, key, solrkey)
        for key, solrkey in REPO_INDEX_I18N_VALUES.iteritems():
            get_useful_value(i18n, key, solrkey)

        contact = self.session.query(models.ContactInformation)\
                .filter(and_(
                    models.ContactInformation.actor_id==repo.id,
                    models.ContactInformation.primary_contact==1)).first()
        if contact is not None:
            ci18n = contact.get_i18n("en")
            for key, solrkey in CONTACT_INDEX_VALUES.iteritems():
                get_useful_value(contact, key, solrkey)
            for key, solrkey in CONTACT_INDEX_I18N_VALUES.iteritems():
                get_useful_value(ci18n, key, solrkey)

            # lat/long a special case
            if contact.latitude and contact.longitude:
                data["location"] = "%s,%s" % (
                    contact.latitude, contact.longitude)
        return data                


    def index_batch(self, data):
        """Index a batch of repos.  TODO: Language stuff"""

        headers = {"Content-type": "application/json"}
        print json.dumps(data)
        body = json.dumps(data)
        h = httplib2.Http()
        resp, content = h.request(
                self.solrurl + "?commit=true", "POST", headers=headers, body=body)

        if resp["status"] != "200":
            print "Unexpected status %s from address: %s" % (
                    resp["status"], self.solrurl)
            print content
            return False
        else:
            print content




if __name__ == "__main__":
    g = IndexRepos()
    g.index()



