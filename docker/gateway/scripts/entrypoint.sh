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

# Fill UCR from environment variables
python3 ./env_to_ucr.py

# Generate config files from UCR templates
univention-config-registry commit \
  /etc/apache2/conf-available/ucs.conf \
  /etc/apache2/conf-available/univention-web.conf \
  /etc/apache2/mods-available/proxy.conf \
  /etc/apache2/mods-available/ssl.conf \
  /etc/apache2/ports.conf \
  /etc/apache2/sites-available/000-default.conf \
  /etc/apache2/sites-available/default-ssl.conf \
  /etc/apache2/sites-available/univention.conf \
  /etc/apache2/sites-available/univention-server-overview.conf \
  /etc/apache2/sites-available/univention-udm.conf \
  /etc/apache2/ucs-sites.conf.d/ucs-sites.conf

# Replace destination of existing univention config
if [[ -z "${UMC_SERVER_URL:-}" ]]; then
  echo "Please set the environmental variable UMC_SERVER_URL"
  exit 126
fi

if [[ -z "${UDM_URL:-}" ]]; then
  echo "Please set the environmental variable UDM_URL"
  exit 126
fi

sed \
  --in-place \
  "s#http://127.0.0.1:8090#$UMC_SERVER_URL#g" \
  /etc/apache2/sites-available/univention.conf

sed \
  --in-place \
  "s#http://127.0.0.1:9979#$UDM_URL#g" \
  /etc/apache2/sites-available/univention-udm.conf

univention-config-registry commit \
  /var/www/univention/languages.json \
  /var/www/univention/meta.json

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

exec /usr/local/apache2/bin/httpd "$@"

# [EOF]