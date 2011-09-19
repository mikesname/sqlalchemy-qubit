"""
SQLAlchemy-Qubit test suite.
"""

import unittest
import tempfile

# turn of warnings we don't care about
import warnings
from sqlalchemy import func, exc as sa_exc

from sqlaqubit import models, keys, load_test_sql, create_engine, init_models


class InformationObjectTest(unittest.TestCase):
    def setUp(self):
        self.session = load_test_sql("data/sqlite.sql")

    def tearDown(self):
        self.session.close()

    def test_get_parent_repo(self):
        parent = self.session.query(models.Actor).\
                filter(models.Actor.id == keys.ActorKeys.ROOT_ID).one()
        self.assertIsNotNone(parent)

    def test_create_repo(self):
        """Test creating a bunch of repositories."""
        numcreate = 5
        parent = self.session.query(models.Actor).\
                with_polymorphic(models.Repository).\
                filter(models.Actor.id == keys.ActorKeys.ROOT_ID).one()
        actors_before = self.session.query(models.Actor).count()
        for i in range(numcreate):
            r = models.Repository(identifier="repo%d" % i,
                    source_culture="en", parent=parent)
            #parent.children.append(r)
            self.session.add(r)
            r.set_i18n(dict(
                authorized_form_of_name="Repo %d" % i), lang="en")
        self.session.commit()

        # create creation count compared to before
        actors_after = self.session.query(models.Actor).count()
        self.assertEqual(actors_before + numcreate, actors_after)

        # check creation count based on query
        q = self.session.query(models.Repository)\
                .filter(models.Repository.identifier.startswith("repo")).all()
        self.assertEqual(len(q), numcreate)

        # check i18n for created objects
        for i in range(numcreate):
            self.assertEqual(
                    q[i].get_i18n()["authorized_form_of_name"], "Repo %d" % i)

        # check nested set behaviour
        self.assertEqual(parent.rgt - parent.lft - 1, numcreate * 2)        

    def test_nested_set_unparent(self):
        """Test nested set behaviour works as expected."""
        numcreate = 5
        parent = self.session.query(models.Actor).\
                with_polymorphic(models.Repository).\
                filter(models.Actor.id == keys.ActorKeys.ROOT_ID).one()

        # check there are no current children                
        self.assertEqual(parent.rgt - parent.lft - 1, 0)

        repos = []
        for i in range(numcreate):
            r = models.Repository(identifier="repo%d" % i,
                    source_culture="en", parent=parent)
            self.session.add(r)
            repos.append(r)
        self.session.commit()

        self.assertEqual(parent.rgt - parent.lft - 1, len(parent.children) * 2)
        children = self.session.query(models.Repository).\
                filter(models.Repository.parent==parent)
        self.assertEqual(len(children.all()), numcreate)

        child1 = children.all()[0]
        child1.parent = None
        self.session.commit()
        self.assertEqual(len(children.all()), numcreate - 1)
        self.assertEqual(parent.rgt - parent.lft - 1, len(parent.children) * 2)
        self.assertEqual(child1.rgt - child1.lft - 1, 0)

    def test_nested_set_reparent(self):
        """Test nested set behaviour works as expected."""
        numcreate = 5
        parent = self.session.query(models.Actor).\
                with_polymorphic(models.Repository).\
                filter(models.Actor.id == keys.ActorKeys.ROOT_ID).one()

        # check there are no current children                
        self.assertEqual(parent.rgt - parent.lft - 1, 0)

        cparent = parent
        repos = []
        for i in range(numcreate):
            r = models.Repository(identifier="repo%d" % i,
                    source_culture="en", parent=cparent)            
            self.session.add(r)
            cparent = r
            repos.append(r)
        self.session.commit()

        self.assertEqual(parent.rgt - parent.lft - 1, numcreate * 2)
        children = self.session.query(models.Repository).\
                filter(models.Repository.parent==parent)
        # parent should only have one (direct) child (but several
        # grandchild)
        self.assertEqual(len(children.all()), 1)                

        # remove the parent's first child (and thus all it's children)
        child1 = repos[0]
        child2 = repos[1]
        self.assertEqual(child1, child2.parent)
        child2.parent = parent
        self.session.commit()

        self.assertEqual(child1.rgt - child1.lft - 1, 0)

    def test_delete(self):
        """Test nested set behaviour works as expected."""
        numcreate = 5
        parent = self.session.query(models.Actor).\
                with_polymorphic(models.Repository).\
                filter(models.Actor.id == keys.ActorKeys.ROOT_ID).one()

        cparent = parent
        repos = []
        for i in range(numcreate):
            r = models.Repository(identifier="repo%d" % i,
                    source_culture="en", parent=cparent)            
            self.session.add(r)
            cparent = r
            repos.append(r)
        self.session.commit()

        self.assertEqual(parent.rgt - parent.lft - 1, numcreate * 2)

        numrepos = self.session.query(models.Repository).count()
        self.assertEqual(numrepos, numcreate)

        [self.session.delete(r) for r in repos]
        self.session.commit()

        numrepos = self.session.query(models.Repository).count()
        self.assertEqual(numrepos, 0)





if __name__ == "__main__":
    unittest.main()

