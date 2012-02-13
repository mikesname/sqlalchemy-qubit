"""
Import a Workbook using XLRD.
"""

import sys

from sqlaqubit.validators import xls


if __name__ == "__main__":
    validator = xls.XLSRepositoryValidator(sys.argv[1])
    validator.validate()
    validator.print_errors()

