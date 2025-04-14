#!/bin/bash
set -euxo pipefail
#
# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2021-2025 Univention GmbH

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
  /etc/apache2/ucs-sites.conf.d/ucs-sites.conf

univention-config-registry commit \
  /var/www/univention/languages.json \
  /var/www/univention/meta.json

# Symlink the theme.css according to UCR setting
/etc/univention/templates/scripts/symlink-web-theme.sh

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

# [EOF]
