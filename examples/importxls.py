"""
Import a Workbook using XLRD.
"""

import sys

from sqlaqubit.validators import xls


if __name__ == "__main__":
    sheet = sys.argv[1]
    validator = xls.XLSValidator(sheet)
    validator.validate_headers()
    validator.validate()
    validator.print_errors()

