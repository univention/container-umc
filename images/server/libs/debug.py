#!/usr/bin/python3
# -*- coding: utf-8 -*-
#
# Univention Debug replacement
#
# Copyright 2021 Univention GmbH
#
# https://www.univention.de/
#
# License: Public Domain (no inventive step)
#

"""Minimal replacement for Univention Debug

This module implements the bare minimum to replace the Univention Debug c-lib
with the Python logging module.
"""

import logging


# Called from univention.management.console.log via log_init
def init(_a, _b, _c):
    """This has been used to initialise the log module"""


# Called from univention.management.console.log via log_set_level
def set_level(_, level):
    """Change the current log-level"""
    logging.getLogger().setLevel(level)


# Called from univention.management.console.log via ILogger.__log
debug = logging.debug

############################################################
# used levels

# Sourced by univention.management.console.log
ERROR = logging.ERROR

# Referenced from univention.management.console.log via ILogger.process
PROCESS = logging.INFO

# Referenced from univention.admin.handlers via ImportError
WARN = logging.WARN

# Referenced from univention.management.console.log via ILogger.info
INFO = logging.INFO

############################################################
# unused components

# Sourced by univention.management.console.log
MAIN = None
LDAP = None
NETWORK = None
SSL = None
ADMIN = None
MODULE = None
AUTH = None
PARSER = None
LOCALE = None
ACL = None
RESOURCES = None
PROTOCOL = None

############################################################
# unused variables

# stub values for the unused init function
FLUSH = None
NO_FUNCTION = None

# [EOF]
