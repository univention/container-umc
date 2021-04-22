#!/usr/bin/python3
#
# Univention Management Console
#  logging module for UMC replacement
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

"""Minimal replacement for Univention Management Console Log

This module implements the bare minimum to replace the UMC-log-lib.
"""

import logging

import univention.debug as ud
from univention.config_registry import ConfigRegistry

# no exceptions from logging otherwise shutdown the server will raise an
# exception that the logging stream could not be closed
logging.raiseExceptions = 0

#: list of available debugging components
COMPONENTS = (
    ud.MAIN,
    ud.LDAP,
    ud.NETWORK,
    ud.SSL,
    ud.ADMIN,
    ud.MODULE,
    ud.AUTH,
    ud.PARSER,
    ud.LOCALE,
    ud.ACL,
    ud.RESOURCES,
    ud.PROTOCOL,
)

_ucr = ConfigRegistry()
_debug_loglevel = 2  # pylint: disable=invalid-name


def _reset_debug_loglevel() -> None:
    """Reconfigure the global _debug_loglevel from UCR"""
    global _debug_loglevel  # pylint: disable=global-statement,invalid-name
    _ucr.load()
    _debug_loglevel = max(
        int(_ucr.get('umc/server/debug/level', 2)),
        int(_ucr.get('umc/module/debug/level', 2)),
    )


_reset_debug_loglevel()


def log_init(
    _filename: str, log_level: int = 2, _log_pid: bool = None
) -> None:
    """Initializes Univention debug

    Args:
        filename: Log-file-path (unused)
        log_level: Univention log level to use (0-3) as defined in debug.py.
        _log_pid: Prefix log message with process ID

    """
    log_set_level(log_level)


def log_set_level(level: int = 0) -> None:
    """Sets the log level for all components.

    Args:
        level: log level to set

    """
    for component in COMPONENTS:
        ud.set_level(component, level)


def log_reopen() -> None:
    """Stub called by univention-management-console-server"""
    _reset_debug_loglevel()
    log_set_level(_debug_loglevel)


class ILogger:
    """Supplies logger objects"""
    def __init__(self, category: str) -> None:
        """Initialize the logger with a category name

        Args:
            category: Name of the logger.

        """
        fmt = (
            f'{{asctime}}.{{msecs:03.0f}} {category:11s} ( {{level:7s}} ) : '
            '{message}'
        )
        formatter = logging.Formatter(
            fmt=fmt,
            datefmt='%Y-%m-%d %H:%M:%S',
            style='{',
        )
        handler = logging.StreamHandler()
        handler.setFormatter(formatter)
        self.logger = logging.getLogger(f'UMC.{category}')
        self.logger.setLevel(logging.DEBUG)
        self.logger.addHandler(handler)

    def error(self, message: str) -> None:
        """Log an error line

        Args:
            message: The message to log.

        """
        self.logger.error(message, extra={'level': 'ERROR'})

    def warn(self, message: str) -> None:
        """Log a warning line

        Args:
            message: The message to log.

        """
        self.logger.warning(message, extra={'level': 'WARN'})

    def process(self, message: str) -> None:
        """Log a process line

        Args:
            message: The message to log.

        """
        self.logger.info(message, extra={'level': 'PROCESS'})

    def info(self, message: str) -> None:
        """Log an info line

        Args:
            message: The message to log.

        """
        self.logger.info(message, extra={'level': 'INFO'})


############################################################
# logger components

# imported from univention-management-console-server and
# univention/management/console/base.py
# univention/management/console/protocol/server.py
CORE = ILogger('MAIN')

# imported from univention/management/console/protocol/server.py
CRYPT = ILogger('SSL')

# imported from univention/management/console/base.py
MODULE = ILogger('MODULE')

# imported from univention/management/console/auth.py
AUTH = ILogger('AUTH')

# imported from univention/management/console/protocol/message.py
PARSER = ILogger('PARSER')

# imported from univention/management/console/locales.py
LOCALE = ILogger('LOCALE')

# imported from univention/management/console/acl.py
ACL = ILogger('ACL')

# imported from univention/management/console/module.py and
# univention/management/console/protocol/server.py
RESOURCES = ILogger('RESOURCES')

# imported from univention/management/console/protocol/message.py
PROTOCOL = ILogger('PROTOCOL')

# [EOF]
