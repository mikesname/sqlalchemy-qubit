"""
Common function and data for Qubit interoperability.
"""

from incf.countryutils import transformations, data as countrydata

def get_country_from_code(code):
    """Get the country code from a coutry name."""
    try:
        name = transformations.cc_to_cn(code)
        return SUBNAMES.get(name, name)
    except KeyError:
        pass

def get_code_from_country(name):
    """Get the country code from a coutry name."""
    revmap = dict((v, k) for k, v in SUBNAMES.iteritems())
    ccn = countrydata.cn_to_ccn.get(revmap.get(name, name))
    if ccn is None:
        return # should raise an error with sheet context
    return countrydata.ccn_to_cca2.get(ccn)


# Hacky dictionary of official country/languages names
# we want to substitute for friendlier versions... 
# A more permenant solution is needed to this.
SUBNAMES = {
    "United Kingdom of Great Britain & Northern Ireland": "United Kingdom",
    "Slovakia (Slovak Republic)" : "Slovak Republic",
    "Holy See (Vatican City State)" : "Vatican City",
    "Russian Federation" : "Russia",
}


