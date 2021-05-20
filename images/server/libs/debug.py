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

############################################################
# components

# Sourced by univention.management.console.log

ACL = 'acl'

# imported from univention/admin/handlers/__init__.py
ADMIN = 'admin'

AUTH = 'auth'

LDAP = 'ldap'

LOCALE = 'locale'

MAIN = 'main'

NETWORK = 'network'

SSL = 'ssl'

MODULE = 'module'

PARSER = 'parser'

PROTOCOL = 'protocol'

RESOURCES = 'resources'

############################################################
# log-levels

# Sourced by univention.management.console.log
ERROR = 0

# Referenced from univention.admin.handlers via ImportError
WARN = 1

# Referenced from univention.management.console.log via ILogger.process
PROCESS = 2

# Referenced from univention.management.console.log via ILogger.info
INFO = 3

# Unused
ALL = 4

# Sometimes used for passwords
SPECIAL = 99

PY_LOG_LEVELS = {
    ERROR: logging.ERROR,
    WARN: logging.WARN,
    PROCESS: logging.INFO,
    INFO: logging.INFO,
    ALL: logging.INFO,
    SPECIAL: logging.DEBUG,
}

logging.getLogger().setLevel(0)


# Called from univention.management.console.log via log_init
def init(_logfile, _flag_flush, _flag_function):
    """This has been used to initialise the log module

    Args:
        _logfile: log-file-path (unused)
        _flag_flush: flash-flag (unused)
        _flag_function: function-flag (unused)

    """
    logging.getLogger('MAIN').log(100, 'DEBUG_INIT')


# Called from univention.management.console.log via log_set_level
def set_level(category: str, level: int):
    """Change the current log-level

    Args:
        category: Name of the category, e.g. MAIN, LDAP, USERS, ...
        level: Level of logging, e.g. ERROR, WARN, PROCESS, INFO, ALL

    """
    # convert univention to python log-level
    pylevel = PY_LOG_LEVELS.get(level, logging.ERROR)
    logging.getLogger(category).setLevel(pylevel)


# Called from univention.management.console.log via ILogger.__log
def debug(category: str, level: int, message: str, _utf8: bool = True) -> None:
    """Log message 'message' of severity 'level' to facility 'category'.

    Args:
        category: Name of the category, e.g. MAIN, LDAP, USERS, ...
        level: Level of logging, e.g. ERROR, WARN, PROCESS, INFO, ALL
        message: The message to log.
        _utf8: Assume the message is UTF-8 encoded. (unused)

    """
    # convert univention to python log-level
    pylevel = PY_LOG_LEVELS[level]
    logging.getLogger(category).log(pylevel, message)


# [EOF]
