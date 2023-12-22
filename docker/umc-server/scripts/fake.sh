#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2023 Univention GmbH


# Used to replace calls from dpkg-postinst scripts

echo 'Faking "'"$(basename "$0")"'" with parameters: "'"$*"'"' 1>&2

exit 0

# [EOF]
