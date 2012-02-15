"""Class for validating an ISDIAH .xls file."""

import re
import datetime
import logging as LOG
from ordereddict import OrderedDict

import phpserialize
import xlrd

from sqlaqubit import utils


class XLSError(Exception):
    """Something went wrong with XLS import."""


ERROR_CODES = {
        u"bad_xls": u"Unable to open XLS file.",
        u"worksheet_not_found": u"Data worksheet must be the first sheet in the workbook.",
        u"unexpected_heading": u"Unexpected headings on worksheet",
}



class XLSValidator(object):
    HEADING_ROW = 0
    HEADINGS = []
    UNIQUES = []
    # Fields that contain multiple values separated
    # by two commas (yep, it's gross): 
    MULTIPLES = []

    def __init__(self, raise_err=False):
        self.workbook = None
        self.sheet = None
        
        self.raise_err = raise_err
        self.errors = []

    def open_xls(self, xlsfile):
        self.workbook = xlrd.open_workbook(xlsfile, formatting_info=True)
        try:
            self.sheet = self.workbook.sheet_by_index(0)
        except IOError:
            self.add_error(None, ERROR_CODES["bad_xls"], fatal=True)
        except IndexError:
            self.add_error(None, ERROR_CODES["worksheet_not_found"], fatal=True)

    def is_valid(self):
        return len(self.errors) > 0

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
        self.errors.append((row, msg, warn))
        if fatal or (self.raise_err and not warn):
            raise XLSError(fullmsg)

    def validate_headers(self):
        """Check header match watch we're expecting."""
        numheads = len(self.HEADINGS)
        heads = [h.value for h in self.sheet.row_slice(self.HEADING_ROW, 0, numheads)]
        diffs = set(heads).difference(self.HEADINGS)
        err = ERROR_CODES["unexpected_heading"]
        if len(diffs) > 0:
            for diff in diffs:
                self.add_error(self.HEADING_ROW, "%s: %s" % (err, diff))
            raise XLSError(err)

    def validate(self, xlspath):
        """Check everything is A-Okay with the XLS data."""
        # These actions will stop any further validation
        # if they error
        try:
            self.open_xls(xlspath)
            self.validate_headers()
        except Exception:
            return
        self.check_unique_columns()
        for row in range(self.HEADING_ROW+1, self.sheet.nrows):
            data = [d.value for d in self.sheet.row_slice(row, 0, len(self.HEADINGS))]
            self.validate_row(row, OrderedDict(zip(self.HEADINGS, data)))

    def validate_row(self, rownum, rowdata):
        """Check a single row of data."""
        self.check_multiples(rownum, rowdata)

    def check_unique_columns(self):
        """Check columns which should contain unique values
        actually do."""
        for colhead in self.UNIQUES:
            col = self.HEADINGS.index(colhead)
            rowsdata = [(i + self.HEADING_ROW, c.value) for i, c in \
                    enumerate(self.sheet.col_slice(
                        col, self.HEADING_ROW, self.sheet.nrows))]
            datarows = OrderedDict()
            for i, key in rowsdata:
                item = datarows.get(key)
                if item is None:
                    datarows[key] = [i]
                else:
                    datarows[key].append(i)
            for key, rows in datarows.iteritems():
                if len(rows) > 1:
                    header = self.sheet.cell(self.HEADING_ROW, col).value
                    self.add_error(
                            rows[0], "Duplicate on unique column: %s: '%s' %s" % (
                                header, key, [r+1 for r in rows[1:]]))


    def check_multiples(self, rownum, rowdata):
        """Check fields that only allow single entries don't
        contain multiple ones."""
        for i, (key, val) in enumerate(rowdata.iteritems()):
            multi = unicode(val).split(",,")
            if len(multi) > 1 and key not in self.MULTIPLES:
                self.add_error(rownum, 
                        "Double-comma separator in a strictly single-value field: '%s'" % key)


class XLSRepositoryValidator(XLSValidator):
    """Validator for Repository import."""
    name = "Repositories"
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
        "authorized_form_of_name",
    ]
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

    def check_countrycode(self, rownum, rowdata):
        """Check we can lookup the country code."""
        code = utils.get_code_from_country(rowdata["country"].strip())
        if code is None:
            self.add_error(rownum, "Unable to find 2-letter country code at row: '%s'" % (
                rowdata["country"],))

    def validate_row(self, rownum, rowdata):
        """Check a single row of data."""
        super(XLSRepositoryValidator, self).validate_row(rownum, rowdata)
        self.check_countrycode(rownum, rowdata)


class XLSCollectionValidator(XLSValidator):
    """Validator for Collection import."""    
    name = "Collections"
    HEADING_ROW = 1 # Zero-based
    HEADINGS = [
        u'institution_identifier',
        u'identifier',
        u'title',
        u'other_forms_of_title',
        u'dates',
        u'level_of_description',
        u'extent_and_medium',
        u'creator',
        u'repository',
        u'scope_and_content',
        u'language',
        u'script',
        u'finding_aids',
        u'location_of_originals',
        u'location_of_copies',
        u'publication_note',
        u'notes',
        u'subject_access',
        u'place_access',
        u'name_access',
        u'rules',
        u'dates_of_administration',
        u'description_identifier',
        u'institution_identifier',
        u'status',
        u'detail',
        u'language_of_description',
        u'script_of_description',
        u'sources',
        u'archivist_note',
        u'ehri_scope',
        u'ehri_priorty',
        u'ehri_copyright',
    ]
    UNIQUES = [
        "identifier",
    ]
    MULTIPLES = [
        "other_forms_of_title",
        "sources",
        "dates",
        "dates_of_administration",
        "language",
        "script",
        "language_of_description",
        "script_of_description",
    ]

    def validate_row(self, rownum, rowdata):
        """Check a single row of data."""
        super(XLSCollectionValidator, self).validate_row(rownum, rowdata)



