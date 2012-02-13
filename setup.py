#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Borrowed largely from django-celery"""

import os
import sys
import codecs
import platform

try:
    from setuptools import setup, find_packages, Command
except ImportError:
    from ez_setup import use_setuptools
    use_setuptools()
    from setuptools import setup, find_packages, Command
from distutils.command.install_data import install_data
from distutils.command.install import INSTALL_SCHEMES

packages, data_files = [], []
root_dir = os.path.dirname(__file__)
if root_dir != '':
    os.chdir(root_dir)
src_dir = "sqlaqubit"


def osx_install_data(install_data):

    def finalize_options(self):
        self.set_undefined_options("install", ("install_lib", "install_dir"))
        install_data.finalize_options(self)


def fullsplit(path, result=None):
    if result is None:
        result = []
    head, tail = os.path.split(path)
    if head == '':
        return [tail] + result
    if head == path:
        return result
    return fullsplit(head, [tail] + result)


for scheme in INSTALL_SCHEMES.values():
    scheme['data'] = scheme['purelib']

SKIP_EXTENSIONS = [".pyc", ".pyo", ".swp", ".swo"]


def is_unwanted_file(filename):
    for skip_ext in SKIP_EXTENSIONS:
        if filename.endswith(skip_ext):
            return True
    return False

for dirpath, dirnames, filenames in os.walk(src_dir):
    # Ignore dirnames that start with '.'
    for i, dirname in enumerate(dirnames):
        if dirname.startswith("."):
            del dirnames[i]
    for filename in filenames:
        if filename.endswith(".py"):
            packages.append('.'.join(fullsplit(dirpath)))
        elif is_unwanted_file(filename):
            pass
        else:
            data_files.append([dirpath, [os.path.join(dirpath, f) for f in
                filenames]])



if os.path.exists("README.txt"):
    long_description = codecs.open("README.txt", "r", "utf-8").read()
else:
    long_description = "See http://github.com/mikesname/sqlalchemy-qubit"


setup(
    name="sqlalchemy-qubit",
    version="0.2",
    description="An mapping of the Qubit data model to SQLAlchemy classes",
    author="Mike Bryant",
    url="http://github.com/mikesname/sqlalchemy-qubit/tree/master",
    platforms=["any"],
    license="BSD",
    packages=packages,
    data_files=data_files,
    scripts=[],
    zip_safe=False,
    install_requires=[
        "ordereddict",
        "sqlalchemy>=0.7.1",
        "incf.countryutils",
        "phpserialize",
        "xlrd",
        "MySQL-python",
    ],
    classifiers=[
        "Development Status :: 1 - Alpha",
        "Environment :: Console",
        "Operating System :: OS Independent",
        "Programming Language :: Python",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: BSD License",
        "Operating System :: POSIX",
        "Topic :: Software Development :: Libraries :: Python Modules",
    ],
    long_description=long_description,
)
