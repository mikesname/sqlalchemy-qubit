"""
SQLAlchemy classes for Qubit database.
"""

from sqlalchemy import create_engine, MetaData
from sqlalchemy.orm import sessionmaker
import models

test_engine = create_engine("mysql+mysqldb://qubit:changeme@localhost/test_ehriqubit?charset=utf8&use_unicode=0")


def load_test_db(dbpath, **kwargs):
    """Load an SQLite file for testing."""
    engine = create_engine("sqlite:///%s" % dbpath, **kwargs)
    init_models(engine)
    return models.Session(bind=engine)


def load_test_sql(sqlpath, **kwargs):
    """Load an SQLite db for testing."""
    engine = create_engine("sqlite://", **kwargs)
    with open(sqlpath, "r") as f:
        cur = engine.raw_connection()
        cur.executescript(f.read())
    init_models(engine)
    return models.Session(bind=engine)


def init_models(engine):
    """Decorator for generating an I18N table
    for the given source table, and placing
    an accessor relationship on the source."""
    models.unregister_i18n()
    models.Base.metadata.bind = engine
    models.Base.metadata.reflect()
    i18nupdate = {}
    for cname in dir(models):
        cls = getattr(models, cname)
        if not hasattr(cls, "__tablename__"):
            continue
        i18nupdate[cname] = cls
    for cname, cls in i18nupdate.iteritems():
        models.init_i18n_class(cls)

