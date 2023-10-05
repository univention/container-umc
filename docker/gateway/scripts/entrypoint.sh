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
ucr set \
    domainname="${DOMAINNAME}" \
    hostname="${HOSTNAME}" \
    apache2/autostart=yes \
    apache2/documentroot="/var/www/" \
    apache2/force_https/exclude/http_host/localhost="localhost" \
    apache2/force_https/exclude/request_uri/mod-status="/server-status" \
    apache2/force_https/exclude/request_uri/univention-portal="/univention/get" \
    apache2/loglevel="warn" \
    apache2/maxclients=150 \
    apache2/startsite="univention/" \
    ucs/server/robots/disallow="/" \
    ucs/server/sso/fqdn="${SSO_FQDN}" \
    umc/http/content-security-policy/connect-src="'self'" \
    umc/http/content-security-policy/default-src="'unsafe-eval'" \
    umc/http/content-security-policy/font-src="'self'" \
    umc/http/content-security-policy/form-action="'self'" \
    umc/http/content-security-policy/frame-ancestors="'self'" \
    umc/http/content-security-policy/frame-src="'self' https://${SSO_FQDN}" \
    umc/http/content-security-policy/img-src="*" \
    umc/http/content-security-policy/media-src="*" \
    umc/http/content-security-policy/object-src="'self'" \
    umc/http/content-security-policy/script-src="'self' 'unsafe-inline' 'unsafe-eval' https://www.youtube.com/ https://s.ytimg.com" \
    umc/http/content-security-policy/style-src="'self' 'unsafe-inline'" \
    umc/login/content-security-policy/frame-ancestors="'self'" \
    umc/self-service/content-security-policy/frame-ancestors="'self'" \
    portal/paths="/univention/portal/, /univention/umc/" \
    locale="de_DE.UTF-8:UTF-8 en_US.UTF-8:UTF-8" \
    ucs/server/languages/de_DE="Deutsch" \
    ucs/server/languages/en_US="English"

# Ensure proper cookie banner config
ucr set umc/cookie-banner/show="${SHOW_COOKIE_BANNER}"
if [[ -n "${COOKIE_BANNER_TITLE_DE:-}" && -n "${COOKIE_BANNER_TEXT_DE:-}" ]]; then
    ucr set umc/cookie-banner/title/de="${COOKIE_BANNER_TITLE_DE}" \
            umc/cookie-banner/text/de="${COOKIE_BANNER_TEXT_DE}"
fi
if [[ -n "${COOKIE_BANNER_TITLE_EN:-}" && -n "${COOKIE_BANNER_TEXT_EN:-}" ]]; then
    ucr set umc/cookie-banner/title/en="${COOKIE_BANNER_TITLE_EN}" \
            umc/cookie-banner/text/en="${COOKIE_BANNER_TEXT_EN}"
fi

# Additional SouvAP configuration (replacing Ansible file patches)
if [[ ${SWP_APPLY_USABILITY_UI_PATCHES:-} == "true" ]]; then
  # "improve_usability_ui_changes | Remove setupSettingsContextMenu from setupMenus()"
  sed --in-place --expression="/setupCertificateMenu();/d" /usr/share/univention-web/js/umc/hooks/default_menu_entries.js
  # "improve_usability_ui_changes | Remove setupHelpMenu from setupMenus()"
  sed --in-place --expression="/setupHelpMenu();/d" /usr/share/univention-web/js/umc/hooks/default_menu_entries.js
  # "improve_usability_ui_changes | Set username maxLength"
  sed --in-place --expression="s/maxLength: 999,/maxLength: 20,/" /usr/share/univention-management-console-frontend/js/umc/modules/udm/UsernameMaxLengthChecker.js
fi

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

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

# [EOF]
