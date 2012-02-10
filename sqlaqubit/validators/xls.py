"""Class for validating an ISDIAH .xls file."""

import re
import datetime
import logging as LOG
from ordereddict import OrderedDict

import phpserialize
import xlrd

from sqlaqubit import utils

HEADING_ROW = 1 # Zero-based
HEADINGS = [
    u'identifier',
    u'authorized_form_of_name',
    u'parallel_forms_of_name',
    u'other_names',
    u'entity_type',
    u'street_address',
    u'postal_code',
    u'city',
    u'region',
    u'country',
    u'telephone',
    u'fax',
    u'email',
    u'website',
    u'contact_person',
    u'primary_contact',
    u'contact_type',
    u'history',
    u'geocultural_context',
    u'collecting_policies',
    u'holdings',
    u'finding_aids',
    u'research_services',
    u'desc_institution_identifier',
    u'institution_responsible_identifier',
    u'rules',
    u'status',
    u'dates_of_existence',
    u'language_of_description',
    u'script_of_description',
    u'sources',
    u'priority',
    u'notes'
]

UNIQUES = [
    1,
]


# Fields that contain multiple values separated
# by two commas (yep, it's gross): 
MULTIPLES = [
    "parallel_forms_of_name",
    "other_names",
    "street_address",
    "email",
    "website",
    "telephone",
    "fax",
    "sources",
]


class XLSError(Exception):
    """Something went wrong with XLS import."""


class XLSValidator(object):
    def __init__(self, xlsfile, raise_err=False):
        self.workbook = xlrd.open_workbook(xlsfile, formatting_info=True)
        try:
            self.sheet = self.workbook.sheet_by_index(0)
        except IndexError:
            raise XLSError("Data worksheet must be the first sheet in the workbook.")
        self.raise_err = raise_err
        self.errors = []

    def print_errors(self):
        # sort by lin num
        errors = sorted(self.errors, key=lambda x: x[0])
        for error in errors:
            fullmsg = "%d: %s" % (error[0], error[1])
            if error[2]:
                LOG.warning(fullmsg)
            else:
                LOG.error(fullmsg)

    def add_error(self, row, msg, warn=False, fatal=False):
        fullmsg = "row %d: %s" % (row+1, msg)
        if self.raise_err and not warn:
            raise XLSError(fullmsg)
        self.errors.append((row, msg, warn))

    def validate_headers(self):
        """Check header match watch we're expecting."""
        numheads = len(HEADINGS)
        heads = [h.value for h in self.sheet.row_slice(HEADING_ROW, 0, numheads)]
        diffs = set(heads).difference(HEADINGS)
        if len(diffs) > 0:
            raise XLSError("Unexpected headings on worksheet: %s" % (
                ", ".join(diffs)))

    def validate(self):
        """Check everything is A-Okay with the XLS data."""
        self.check_unique_columns()
        for row in range(HEADING_ROW+1, self.sheet.nrows):
            data = [d.value for d in self.sheet.row_slice(row, 0, len(HEADINGS))]
            self.validate_row(row, OrderedDict(zip(HEADINGS, data)))

    def validate_row(self, rownum, rowdata):
        """Check a single row of data."""
        self.check_multiples(rownum, rowdata)
        self.check_countrycode(rownum, rowdata)

    def check_unique_columns(self):
        """Check columns which should contain unique values
        actually do."""
        for col in UNIQUES:
            rowsdata = [(i + HEADING_ROW, c.value) for i, c in \
                    enumerate(self.sheet.col_slice(
                        col, HEADING_ROW, self.sheet.nrows))]
            datarows = OrderedDict()
            for i, key in rowsdata:
                item = datarows.get(key)
                if item is None:
                    datarows[key] = [i]
                else:
                    datarows[key].append(i)
            for key, rows in datarows.iteritems():
                if len(rows) > 1:
                    header = self.sheet.cell(HEADING_ROW, col).value
                    self.add_error(
                            rows[0], "Duplicate on unique column: %s: '%s' %s" % (
                                header, key, rows[1:]))


    def check_multiples(self, rownum, rowdata):
        """Check fields that only allow single entries don't
        contain multiple ones."""
        for i, (key, val) in enumerate(rowdata.iteritems()):
            multi = unicode(val).split(",,")
            if len(multi) > 1 and key not in MULTIPLES:
                self.add_error(rownum, 
                        "Double-comma separator in a strictly single-value field: '%s'" % key)

    def check_countrycode(self, rownum, rowdata):
        """Check we can lookup the country code."""
        code = utils.get_code_from_country(rowdata["country"].strip())
        if code is None:
            self.add_error(rownum, "Unable to find 2-letter country code at row: '%s'" % (
                rowdata["country"],))



