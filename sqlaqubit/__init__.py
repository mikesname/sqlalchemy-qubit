"""
SQLAlchemy classes for Qubit database.
"""

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import models

engine = create_engine("mysql+mysqldb://qubit:changeme@localhost/test_ehriqubit?charset=utf8&use_unicode=0")


def init(engine):
    """Decorator for generating an I18N table
    for the given source table, and placing
    an accessor relationship on the source."""
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

