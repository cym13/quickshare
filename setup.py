#!/usr/bin/env python
# -*- coding: utf-8 -*-

# From https://raw.githubusercontent.com/pypa/sampleproject/master/setup.py
from setuptools import setup, find_packages
from codecs import open
from os import path

setup(
    name='qs',

    # Versions should comply with PEP440.  For a discussion on single-sourcing
    # the version across setup.py and the project code, see
    # http://packaging.python.org/en/latest/tutorial.html#version
    version='1.4.2',

    description='CLI program to quickly share directories using a http server',

    # The project's main homepage.
    url='https://github.com/cym13/quickshare',

    # Author details
    author='Cédric Picard',
    author_email='cedric.picard@efrei.net',

    # Choose your license
    license='GPLv3',

    # See https://pypi.python.org/pypi?%3Aaction=list_classifiers
    classifiers=[
        # How mature is this project? Common values are
        #   3 - Alpha
        #   4 - Beta
        #   5 - Production/Stable
        'Development Status :: 5 - Production/Stable',

        # Specify the Python versions you support here. In particular, ensure
        # that you indicate whether you support Python 2, Python 3 or both.
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.2',
        'Programming Language :: Python :: 3.3',
        'Programming Language :: Python :: 3.4',
    ],

    # What does your project relate to?
    keywords='cli quick share file http server',

    # Scripts
    scripts = ['qs'],

    # List run-time dependencies here.  These will be installed by pip when your
    # project is installed. For an analysis of "install_requires" vs pip's
    # requirements files see:
    # https://packaging.python.org/en/latest/technical.html#install-requires-vs-requirements-files
    install_requires=['docopt']
)
