#!/usr/bin/python3
# -*- coding: utf-8 -*-
#
# Univention Directory Manager Password replacement
#
# Copyright 2021 Univention GmbH
#
# https://www.univention.de/
#
# License: Public Domain (no inventive step)
#

"""UDM Password replacement

Non-functional replacement for
`.../dist-packages/univention/admin/password.py`
from the package `python3-univention-directory-manager`.

It is sourced by
`.../dist-packages/univention/admin/handlers/computers/__base.py`.

Added to avoid a dependency to the package python3-smbpasswd which is
currently not available.
"""

# [EOF]
