#!/usr/bin/python3
#
# Univention Config Registry replacement
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

"""UCR replacement

Functional replacement for
`.../dist-packages/univention/config_registry`
from the package `python3-univention-config-registry`.

Unlike the original this only loads settings from environmental variables for
easier Docker handling.

It is sourced by `.../dist-packages/univention/admin/uldap.py`.
"""

import logging
import os

CONFIG = {
    'umc/http/dispatch-interval':
        os.environ.get('DISPATCH_INTERVAL', '100'),
    'umc/http/interface':
        os.environ.get('INTERFACE', '0.0.0.0'),
    'umc/http/max-open-file-descriptors':
        os.environ.get('MAX_OPEN_FILE_DESCRIPTORS', '65535'),
    'umc/http/max_request_body_size':
        os.environ.get('MAX_REQUEST_BODY_SIZE', '104857600'),
    'umc/http/maxthreads':
        os.environ.get('MAX_THREADS', '35'),
    'umc/http/response-timeout':
        os.environ.get('RESPONSE_TIMEOUT', '310'),
    'umc/http/requestqueuesize':
        os.environ.get('REQUEST_QUEUE_SIZE', '100'),
}


class ConfigRegistry:
    """ucr main class"""
    def __init__(self):
        self.config = {}
        return

    def load(self):
        """Stub-function for loading UCR-items"""
        logging.debug('ucr load')
        self.config = CONFIG
        return

    def __getitem__(self, key: str) -> str:
        """To get value of an UCR-item like from a dict

        Args:
            key: UCR item name

        Returns:
            Item value or None if not set

        """
        result = self.config.get(key, None)
        logging.debug('ucr __getitem__ %s -> %s', key, result)
        return result

    def get(self, key: str, default: str = None) -> str:
        """Read the value of an UCR-item

        Args:
            key: UCR item name
            default: value to return if item is not set

        Returns:
            Item value or default if not set

        """
        result = self.config.get(key, default)
        logging.debug('ucr get %s, %s -> %s', key, default, result)
        return result

    def is_true(self, key: str, default: bool = True) -> bool:
        """Interprets if UCR value as boolean

        Args:
            key: UCR item name
            default: value to return if item is not set

        Returns:
            Boolean interpretation of the ucr-value or default if not set.

        """
        value = self.config.get(key)
        if value is None:
            return default
        result = value.lower() in (
            'yes',
            'true',
            '1',
            'enable',
            'enabled',
            'on',
        )
        logging.debug('ucr is_true %s %s %s -> %s', key, default, value, result)
        return result

    def is_false(self, key: str, default: bool = False) -> bool:
        """Interprets if UCR value as boolean

        Args:
            key: UCR item name
            default: value to return if item is not set

        Returns:
            Boolean interpretation of the ucr-value or default if not set.

        """
        value = self.config.get(key)
        if value is None:
            return default
        result = value.lower() in (
            'no',
            'false',
            '0',
            'disable',
            'disabled',
            'off',
        )
        logging.debug(
            'ucr is_false %s %s %s -> %s', key, default, value, result
        )
        return result


# [EOF]
