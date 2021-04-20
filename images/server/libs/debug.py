#!/usr/bin/python3
#
# Univention Debug replacement
#
# Copyright 2021 Univention GmbH
#
# https://www.univention.de/
#
# All rights reserved.
#
# The source code of this program is made available
# under the terms of the GNU Affero General Public License version 3
# (GNU AGPL V3) as published by the Free Software Foundation.
#
# Binary versions of this program provided by Univention to you as
# well as other copyrighted, protected or trademarked materials like
# Logos, graphics, fonts, specific documentations and configurations,
# cryptographic keys etc. are subject to a license agreement between
# you and Univention and not subject to the GNU AGPL V3.
#
# In the case you use this program under the terms of the GNU AGPL V3,
# the program is provided in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public
# License with the Debian GNU/Linux or Univention distribution in file
# /usr/share/common-licenses/AGPL-3; if not, see
# <https://www.gnu.org/licenses/>.
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
