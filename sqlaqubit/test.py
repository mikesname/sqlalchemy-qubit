"""
SQLAlchemy-Qubit test suite.
"""

import unittest


from sqlaqubit import models, init_models, create_engine


class InformationObjectTest(unittest.TestCase):
    def setUp(self):
        self.engine = create_engine("sqlite:///testdb.db")

    def tearDown(self):
        print "Tearing down"
        pass

    def test_foo(self):
        print "Testing foo"


if __name__ == "__main__":
    unittest.main()

