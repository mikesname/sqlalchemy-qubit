SQLAlchemy-Qubit is an attempt to create an SQLAlchemy ORM mapping for the Qubit Toolkit's data model.  The Qubit Toolkit is an
information management system developed by Artefactual Systems, built on PHP5 and the Symfony framework.  It is used as
the basis of ICA-Atom, and other library management tools.

The intended purpose of the SQLAlchemy ORM mapping is to facilitate data import and export from Python-based tools.  It is not
affiliated with the creators of the Qubit Toolkit.

http://qubit-toolkit.org/

Example usage:::

    #import the library
    from sqlaqubit import models, init_models, create_engine

    # create an engine using the appropriate DB string: not charset is important
    engine = create_engine("mysql://qubit:changeme@localhost/test_ehriqubit?charset=utf8")

    # initialise the models.  This prompts sqlalchemy to introspect the database and
    # create appropriate I18N models for each of the defined I18N-enabled entities
    init_models(engine)

    # start a session
    session = models.Session()

    # list all the repository identifiers
    for repo in session.query(models.Repository).all():
        print repo.identifier

    # get specific repository
    repo = session.query(models.Repository)\
            .filter(models.Repository.identifier == "ehri11AT")\
            .first()

    # show i18n fields for language "en" (the default)
    for k, v in repo.get_i18n("en").iteritems():
        print "%-20s : %s" % (k, v)

    # set i18n values
    repo.set_i18n(
            dict(authorized_form_of_name="Bludenz, Stadtarchiv"), "en")

    # don't forget to commit the changes commit the changes
    session.commit()


