#!/bin/bash
set -euxo pipefail
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

# SWP Config - Allow to configure the HTML title in the UMC
# https://git.knut.univention.de/univention/customers/dataport/team-souvap/-/issues/172
if [ -n "${UMC_HTML_TITLE}" ]; then
  sed --in-place --expression="s|<title>[^<]*</title>|<title>${UMC_HTML_TITLE}</title>|g" /usr/share/univention-management-console-login/index.html
  sed --in-place --expression="s|<title>[^<]*</title>|<title>${UMC_HTML_TITLE}</title>|g" /usr/share/univention-management-console-frontend/index.html
  sed --in-place --expression="s|window.document.title = [^;]*|window.document.title = '${UMC_HTML_TITLE}'|g" /usr/share/univention-management-console-frontend/main.js
fi

# [EOF]
