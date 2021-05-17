#!/bin/sh
set -eux
umask 077

# Apache Gateway to UMC-Webserver Script
# Copyright (C) 2021 Univention GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>
# https://spdx.org/licenses/AGPL-3.0-only.html

# Full name: GNU Affero General Public License v3.0 only
# Short identifier: AGPL-3.0-only
# Website: https://spdx.org/licenses/AGPL-3.0-only.html

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
sed \
  --in-place \
  "s#http://127.0.0.1:8090#$UMC_PROTOCOL://$UMC_HOST:$UMC_PORT#g" \
  /etc/apache2/sites-available/univention.conf

sed \
  --in-place \
  "s#http://127.0.0.1:9979#$UDM_PROTOCOL://$UDM_HOST:$UDM_PORT#g" \
  /etc/apache2/sites-available/univention-udm.conf

univention-config-registry commit \
  /var/www/univention/languages.json \
  /var/www/univention/meta.json

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

exec /usr/local/apache2/bin/httpd "$@"

# [EOF]
