#!/bin/bash
set -euxo pipefail
umask 077

# Univention Management Console Docker Entrypoint Script
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


############################################################
# Prepare LDAP TLS certificates and settings
TLS_MODE="${TLS_MODE:-secure}"

case "${TLS_MODE}" in
  "secure")
    PAM_LDAP_TLS="starttls"
    TLS_REQCERT="demand"
    ULDAP_START_TLS=2
    ;;
  "unvalidated")
    PAM_LDAP_TLS="starttls"
    TLS_REQCERT="allow"
    ULDAP_START_TLS=1
    SASL_SECPROPS="none,minssf=0"
    ;;
  "off")
    PAM_LDAP_TLS="off"
    TLS_REQCERT="never"
    ULDAP_START_TLS=0
    SASL_SECPROPS="none,minssf=0"
    ;;
  *)
    echo "TLS_MODE must be one of: secure, unvalidated, off."
    exit 1
esac

if [[ "${TLS_MODE}" != "off" ]]; then
  CA_CERT_FILE=${CA_CERT_FILE:-/run/secrets/ca_cert}
  CA_DIR="/etc/univention/ssl/ucsCA"

  mkdir --parents "${CA_DIR}"
  ln --symbolic --force "${CA_CERT_FILE}" "${CA_DIR}/CAcert.pem"
fi

############################################################
# Load SAML metadata
SAML_METADATA_BASE=/usr/share/univention-management-console/saml/idp
CERT_PEM_FILE=${CERT_PEM_FILE:-/run/secrets/cert_pem}
PRIVATE_KEY_FILE=${PRIVATE_KEY_FILE:-/run/secrets/private_key}

if [[ -n "${SAML_METADATA_URL:-}" ]]; then
  echo "SAML Service Provider: enabled"

  if [[ -z "${SAML_SP_SERVER:-}" ]]; then
    echo "\$SAML_SP_SERVER must be set for SAML support"
    exit 255
  fi
  if [[ ! -f "${CERT_PEM_FILE}" ]]; then
    echo "\$CERT_PEM_FILE is not pointing to a file at ${CERT_PEM_FILE}"
    exit 255
  fi
  if [[ ! -f "${PRIVATE_KEY_FILE}" ]]; then
    echo "\$PRIVATE_KEY_FILE is not pointing to a file at ${PRIVATE_KEY_FILE}"
    exit 255
  fi
  if [[ -z "${SAML_METADATA_URL_INTERNAL:-}" ]]; then
    echo "SAML_METADATA_URL_INTERNAL is not set! Assuming it to equal SAML_METADATA_URL."
    SAML_METADATA_URL_INTERNAL=${SAML_METADATA_URL}
  fi

  SAML_IDP_HOST=$(echo "${SAML_METADATA_URL}" | awk -F/ '{print $3}')
  SAML_METADATA_PATH="${SAML_METADATA_BASE}/${SAML_IDP_HOST}.xml"

  echo "Trying to fetch SAML metadata from ${SAML_METADATA_URL_INTERNAL}"
  result=1
  counter=3
  # 'Connection refused' is not retried by `wget --tries=X` hence the loop
  while [[ ${result} -gt 0 && ${counter} -gt 0 ]]; do
    {
        wget \
          --quiet \
          --timeout=3 \
          --tries=2 \
          --header="Host: ${SAML_IDP_HOST}" \
          --output-document="${SAML_METADATA_PATH}" \
          "${SAML_METADATA_URL_INTERNAL}" \
        && result=0
    } || true

    counter=$((counter-1))
    sleep 3
  done

  if [[ ${result} -gt 0 ]]; then
    echo "Error: Failed to fetch saml_metadata from ${SAML_METADATA_URL_INTERNAL}" >&2
    exit 255
  fi

  echo "Successfully set SAML metadata in ${SAML_METADATA_PATH}"

  ucr set umc/saml/idp-server="${SAML_METADATA_URL}"
  ucr set umc/saml/sp-server="${SAML_SP_SERVER}"

  mkdir --parents "/etc/univention/ssl/${SAML_SP_SERVER}"
  ln --symbolic --force "${CERT_PEM_FILE}" "/etc/univention/ssl/${SAML_SP_SERVER}/cert.pem"
  ln --symbolic --force "${PRIVATE_KEY_FILE}" "/etc/univention/ssl/${SAML_SP_SERVER}/private.key"
else
  echo "SAML Service Provider: disabled"
fi

############################################################
# Store LDAP configuration
cat <<EOF > /etc/ldap/ldap.conf
# This file should be world readable but not world writable.

${CA_DIR:+TLS_CACERT /etc/univention/ssl/ucsCA/CAcert.pem}
TLS_REQCERT ${TLS_REQCERT}

URI ldap://${LDAP_HOST}:${LDAP_PORT}

BASE ${LDAP_BASE_DN}

${SASL_SECPROPS:+SASL_SECPROPS ${SASL_SECPROPS}}
EOF
chmod 0644 /etc/ldap/ldap.conf

# TODO: Does this container really need to know this secret?
LDAP_SECRET_FILE=${LDAP_SECRET_FILE:-/run/secrets/ldap_secret}
if [[ -f "${LDAP_SECRET_FILE}" ]]; then
  echo "Using LDAP admin secret"
  ln --symbolic --force "${LDAP_SECRET_FILE}" /etc/ldap.secret
else
  echo "No LDAP admin secret provided!"
fi

# Password which belongs to the LDAP_HOST_DN machine account
MACHINE_SECRET_FILE=${MACHINE_SECRET_FILE:-/run/secrets/machine_secret}
if [[ -f "${MACHINE_SECRET_FILE}" ]]; then
  echo "Using LDAP machine secret from file"
  ln --symbolic --force "${MACHINE_SECRET_FILE}" /etc/machine.secret
elif [[ -n "${MACHINE_SECRET}" ]]; then
  echo "Using LDAP machine secret from env"
  echo -n "${MACHINE_SECRET}" > /etc/machine.secret
else
  echo "No LDAP machine secret found at ${MACHINE_SECRET_FILE} and \$MACHINE_SECRET not set!"
  echo "Check the \$MACHINE_SECRET_FILE variable and the file that it points to."
  exit 1
fi

# By default, disable binding the session to the client IP,
# as the client IP cannot be determined in K8s depending, on the ingress/istio/... config.
LOCAL_IP_RANGES=${LOCAL_IP_RANGES:-0.0.0.0/0,::/0}
# In order to mitigate the security implications,
# limit the cookies to the duration of the Browser session.
ENFORCE_SESSION_COOKIE=${ENFORCE_SESSION_COOKIE:-true}

# TODO: Do we have to set ldap/server/ip as well?
ucr set \
    ldap/master="${LDAP_HOST}" \
    ldap/master/port="${LDAP_PORT}" \
    ldap/server/name="${LDAP_HOST}" \
    ldap/server/port="${LDAP_PORT}" \
    ldap/hostdn="${LDAP_HOST_DN}" \
    ldap/base="${LDAP_BASE_DN}" \
    domainname="${DOMAINNAME}" \
    hostname="${HOSTNAME}" \
    portal/auth-mode="saml" \
    umc/http/allowed-session-overtake/ranges="${LOCAL_IP_RANGES}" \
    umc/http/interface="0.0.0.0" \
    umc/http/enforce-session-cookie="${ENFORCE_SESSION_COOKIE}" \
    umc/http/port=8090 \
    umc/module/debug/level="${DEBUG_LEVEL}" \
    umc/self-service/allow-authenticated-use=true \
    umc/self-service/profiledata/enabled=true \
    umc/server/debug/level="${DEBUG_LEVEL}" \
    umc/server/processes=1 \
    umc/web/favorites/default="welcome,udm:users/user,udm:groups/group,udm:computers/computer,appcenter:appcenter,updater" \
    umc/web/sso/enabled=true \
    ad/member=false \
    auth/methods="ldap" \
    directory/manager/templates/alphanum/whitelist="" \
    directory/manager/user/activate_ldap_attribute_mailForwardCopyToSelf="yes" \
    directory/manager/user_group/uniqueness="true" \
    directory/manager/web/language="de_DE.UTF-8" \
    directory/manager/web/modules/autosearch="1" \
    directory/manager/web/modules/computers/computer/add/default="computers/windows" \
    directory/manager/web/modules/groups/group/caching/uniqueMember/timeout="300" \
    directory/manager/web/modules/groups/group/checks/circular_dependency="yes" \
    directory/manager/web/modules/search/advanced_on_open="false" \
    directory/manager/web/modules/users/user/properties/homePostalAddress/syntax="postalAddress" \
    directory/manager/web/modules/wizards/disabled="no" \
    directory/manager/web/sizelimit="2000" \
    directory/reports/cleanup/age="43200" \
    directory/reports/cleanup/cron="0 0 * * *" \
    directory/reports/logo="/usr/share/univention-directory-reports/univention_logo.png" \
    directory/reports/templates/csv/computer1="computers/computer \"CSV Report\" /etc/univention/directory/reports/default computers.csv" \
    directory/reports/templates/csv/group1="groups/group \"CSV Report\" /etc/univention/directory/reports/default groups.csv" \
    directory/reports/templates/csv/user1="users/user \"CSV Report\" /etc/univention/directory/reports/default users.csv" \
    directory/reports/templates/pdf/computer1="computers/computer \"PDF Document\" /etc/univention/directory/reports/default computers.rml" \
    directory/reports/templates/pdf/group1="groups/group \"PDF Document\" /etc/univention/directory/reports/default groups.rml" \
    directory/reports/templates/pdf/user1="users/user \"PDF Document\" /etc/univention/directory/reports/default users.rml" \
    groups/default/domainadmins="Domain Admins" \
    groups/default/printoperators="Printer-Admins" \
    license/base="dc=example,dc=org" \
    locale/default="de_DE.UTF-8:UTF-8" \
    locale="de_DE.UTF-8:UTF-8 en_US.UTF-8:UTF-8" \
    password/hashing/method="SHA-512" \
    saml/idp/authsource="univention-ldap" \
    saml/idp/certificate/certificate="/etc/simplesamlphp/ucs-sso.example.org-idp-certificate.crt" \
    saml/idp/certificate/privatekey="/etc/simplesamlphp/ucs-sso.example.org-idp-certificate.key" \
    saml/idp/enableSAML20-IdP="true" \
    saml/idp/entityID="https://ucs-sso.example.org/simplesamlphp/saml2/idp/metadata.php" \
    saml/idp/https="true" \
    saml/idp/ldap/get_attributes="'uid', 'mailPrimaryAddress', 'memberOf', 'enabledServiceProviderIdentifier'" \
    saml/idp/ldap/search_attributes="'uid', 'mailPrimaryAddress'" \
    saml/idp/lookandfeel/theme="univentiontheme:univention" \
    saml/idp/negotiate="true" \
    saml/idp/session-duration="43200" \
    saml/idp/show-error-reporting="true" \
    saml/idp/show-errors="true" \
    server/role="domaincontroller_master" \
    ssl/ca/cipher="aes256" \
    ssl/common="Univention Corporate Server Root CA (ID=XXX)" \
    ssl/country="DE" \
    ssl/crl/interval="7" \
    ssl/crl/validity="10" \
    ssl/default/bits="2048" \
    ssl/default/days="1825" \
    ssl/default/hashfunction="sha256" \
    ssl/email="ssl@example.org" \
    ssl/host/objectclass="univentionDomainController,univentionMemberServer,univentionClient" \
    ssl/locality="DE" \
    ssl/organization="DE" \
    ssl/organizationalunit="Univention Corporate Server" \
    ssl/state="DE" \
    ssl/update/expired="yes" \
    ssl/validity/check="yes" \
    ssl/validity/host="20523" \
    ssl/validity/root="20523" \
    ssl/validity/warning="30" \
    system/setup/showloginmessage="false" \
    ucr/backup/enabled="yes" \
    ucr/encoding/strict="true" \
    ucs/server/languages/de_AT="Deutsch (Österreich)" \
    ucs/server/languages/de_CH="Deutsch (Schweiz)" \
    ucs/server/languages/de_DE="Deutsch" \
    ucs/server/languages/en_GB="English (United Kingdom)" \
    ucs/server/languages/en_US="English" \
    ucs/server/robots/disallow="/" \
    ucs/server/saml-idp-server/primary.example.org="primary.example.org" \
    ucs/server/sso/fqdn="ucs-sso.example.org" \
    ucs/server/sso/virtualhost="true" \
    ucs/web/license/requested="true" \
    uldap/start-tls="${ULDAP_START_TLS}" \
    umc/http/autostart="yes" \
    umc/http/content-security-policy/connect-src="'self'" \
    umc/http/content-security-policy/default-src="'unsafe-eval'" \
    umc/http/content-security-policy/font-src="'self'" \
    umc/http/content-security-policy/form-action="'self'" \
    umc/http/content-security-policy/frame-ancestors="'self'" \
    umc/http/content-security-policy/frame-src="*" \
    umc/http/content-security-policy/img-src="*" \
    umc/http/content-security-policy/media-src="*" \
    umc/http/content-security-policy/object-src="'self'" \
    umc/http/content-security-policy/script-src="'self' 'unsafe-inline' 'unsafe-eval' https://www.youtube.com/ https://s.ytimg.com/" \
    umc/http/content-security-policy/style-src="'self' 'unsafe-inline'" \
    umc/http/response-timeout="310" \
    umc/http/session/timeout="28800" \
    umc/login/content-security-policy/frame-ancestors="'self'" \
    umc/login/links/how_do_i_login/enabled="true" \
    umc/login/links/login_without_sso/enabled="true" \
    umc/login/links/login_without_sso/text/de="Ohne Single Sign-On anmelden" \
    umc/login/links/login_without_sso/text="Login without Single Sign On" \
    umc/module/timeout="600" \
    umc/module/udm/users/self/disabled="true" \
    umc/saml/idp-server="${SAML_METADATA_URL:-https://ucs-sso.example.org/simplesamlphp/saml2/idp/metadata.php}" \
    umc/saml/trusted/sp/primary.example.org="primary.example.org" \
    umc/server/autostart="yes" \
    umc/server/upload/max="2048" \
    umc/server/upload/min_free_space="51200" \
    umc/web/appliance/fast_setup_mode="true" \
    umc/web/cache_bust="1619020256" \
    umc/web/feedback/description="[UMC-Feedback] Traceback" \
    umc/web/feedback/mail="feedback@univention.de" \
    umc/web/hooks/univention-management-console-module-passwordchange="passwordchange" \
    umc/web/hooks/univention-web-js="default_menu_entries" \
    umc/web/language="de_DE.UTF-8:UTF-8" \
    umc/web/sso/newwindow="true" \
    umc/web/startupdialog="false" \
    update/available="false" \
    update/reboot/required="false" \
    uuid/license="00000000-0000-0000-0000-000000000000" \
    uuid/system="00000000-0000-0000-0000-000000000000" \
    version/erratalevel="0" \
    version/patchlevel="4" \
    version/version="5.0"


if [[ "${APPLY_SWP_CUSTOMIZATION:-false}" = "true" ]]
then
  echo "Applying SWP customization."

  # TODO: Move SWP customization out once a solution to customize UCR settings has
  # been added into the UMS Stack.
  #
  # See: https://git.knut.univention.de/univention/customers/dataport/team-souvap/-/issues/151
  ucr set \
      directory/manager/web/modules/users/user/properties/mailPrimaryAddress/required="true" \
      directory/manager/web/modules/users/user/properties/firstname/required="true" \
      directory/manager/web/modules/wizard/disabled="No" \
      directory/manager/web/modules/users/user/wizard/property/invite/default="True" \
      directory/manager/web/modules/users/user/wizard/property/overridePWLength/visible="False" \
      directory/manager/web/modules/users/user/wizard/property/overridePWLength/default="False" \
      directory/manager/web/modules/users/user/wizard/property/pwdChangeNextLogin/visible="False" \
      directory/manager/web/modules/users/user/wizard/property/pwdChangeNextLogin/default="True" \
      directory/manager/web/modules/users/user/search/autosearch="False" \
      directory/manager/web/modules/users/user/properties/username/syntax="uid"
else
  echo "Not applying SWP customization."
fi


############################################################
# Configure PAM
ln --symbolic --force "${MACHINE_SECRET_FILE}" /etc/pam_ldap.secret
univention-config-registry commit \
  /etc/pam_ldap.conf \
  /etc/pam.d/univention-management-console
sed -i 's/password.*requisite.*pam_cracklib.so/password required  pam_cracklib.so/; /pam_unix/d; /pam_krb5/d' /etc/pam.d/univention-management-console

if [[ -n "${SAML_SP_SERVER:-}" ]]; then
  # use the first given SAML scheme instead of the UCR template string
  SCHEME=$(echo "${SAML_SCHEMES}" | cut -d, -f1)
  sed --in-place \
    --expression="s#trusted_sp=[[:alpha:]]*#${SCHEME}#" \
    "/etc/pam.d/univention-management-console"
fi

sed --in-place --expression="s/^ssl .*\$/ssl ${PAM_LDAP_TLS}/" /etc/pam_ldap.conf

############################################################
# Generate config files from UCR
univention-config-registry commit \
  /var/www/univention/meta.json

univention-config-registry commit \
  /etc/univention/directory/reports/config.ini \
  /etc/univention/directory/reports/default/de_DE/header.rml \
  /etc/univention/directory/reports/default/de_DE/footer.rml \
  /etc/univention/directory/reports/default/en_US/header.rml \
  /etc/univention/directory/reports/default/en_US/footer.rml

############################################################
# Create storage location for ACLs, in case no volume is mounted
mkdir -p /var/cache/univention-management-console/acls

############################################################
# Run!
exec "/usr/sbin/univention-management-console-server" "$@"

# [EOF]
