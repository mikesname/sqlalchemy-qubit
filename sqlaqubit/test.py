"""
SQLAlchemy-Qubit test suite.
"""

import unittest
import tempfile

# turn of warnings we don't care about
import warnings
from sqlalchemy import exc as sa_exc

from sqlaqubit import models, keys, init_models, create_engine


class InformationObjectTest(unittest.TestCase):
    def setUp(self):
        self.engine = create_engine("sqlite://")
        with open("data/sqlite.sql", "r") as sql:
            cur = self.engine.raw_connection().cursor()
            cur.executescript(sql.read())
        self.session = models.Session()

        with warnings.catch_warnings():
            warnings.simplefilter("ignore", category=sa_exc.SAWarning)
            init_models(self.engine)

    def tearDown(self):
        self.engine.raw_connection().close()

    def test_get_parent_repo(self):
        parent = self.session.query(models.Actor).\
                filter(models.Actor.id == keys.ActorKeys.ROOT_ID).one()
        self.assertIsNotNone(parent)

    def test_create_repo(self):
        parent = self.session.query(models.Actor).\
                filter(models.Actor.id == keys.ActorKeys.ROOT_ID).one()
        actors_before = self.session.query(models.Actor).count()
        for i in range(5):
            r = models.Repository(id=i+10000, identifier="repo%d" % i,
                    source_culture="en", parent=parent)
            self.session.add(r)
            #r.set_i18n(dict(
            #    authorized_form_of_name="Repo %d" % i), lang="en")
        self.session.commit()
        actors_after = self.session.query(models.Actor).count()
        self.assertEqual(actors_before, actors_after - 5)



if __name__ == "__main__":
    unittest.main()

