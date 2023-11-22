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
UDM_STARTTLS=$(ucr get uldap/start-tls)
if [[ -z "${UDM_STARTTLS}" ]]; then
  UDM_STARTTLS=2
fi

case "${UDM_STARTTLS}" in
  "2")
    PAM_LDAP_TLS="starttls"
    TLS_REQCERT="demand"
    ;;
  "1")
    PAM_LDAP_TLS="starttls"
    TLS_REQCERT="allow"
    SASL_SECPROPS="none,minssf=0"
    ;;
  "0")
    PAM_LDAP_TLS="off"
    TLS_REQCERT="never"
    SASL_SECPROPS="none,minssf=0"
    ;;
  *)
    echo "UCR variable 'uldap/start-tls' must be one of: 0, 1, 2"
    exit 1
esac

if [[ "${TLS_REQCERT}" != "never" ]]; then
  CA_CERT_FILE=${CA_CERT_FILE:-/run/secrets/ca_cert}
  CA_DIR="/etc/univention/ssl/ucsCA"

  mkdir --parents "${CA_DIR}"
  ln --symbolic --force "${CA_CERT_FILE}" "${CA_DIR}/CAcert.pem"
fi

############################################################
# Load SAML metadata
SAML_METADATA_BASE=/usr/share/univention-management-console/saml/idp
SAML_METADATA_URL=$(ucr get umc/saml/idp-server)
SAML_METADATA_URL_INTERNAL=$(ucr get umc/saml/idp-server-internal)
SAML_SP_SERVER=$(ucr get umc/saml/sp-server)
CERT_PEM_FILE=${CERT_PEM_FILE:-/run/secrets/cert_pem}
PRIVATE_KEY_FILE=${PRIVATE_KEY_FILE:-/run/secrets/private_key}

if [[ -n "${SAML_METADATA_URL:-}" ]]; then
  echo "SAML Service Provider: enabled"

  if [[ -z "${SAML_SP_SERVER:-}" ]]; then
    echo "'umc/saml/sp-server' must be set for SAML support"
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
    echo "'umc/saml/idp-server-internal' is not set! Assuming it equal to 'umc/saml/idp-server'."
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

  mkdir --parents "/etc/univention/ssl/${SAML_SP_SERVER}"
  ln --symbolic --force "${CERT_PEM_FILE}" "/etc/univention/ssl/${SAML_SP_SERVER}/cert.pem"
  ln --symbolic --force "${PRIVATE_KEY_FILE}" "/etc/univention/ssl/${SAML_SP_SERVER}/private.key"
else
  echo "SAML Service Provider: disabled"
fi

############################################################
# Store LDAP configuration
LDAP_HOST=$(ucr get ldap/master)
LDAP_PORT=$(ucr get ldap/master/port)
LDAP_BASE_DN=$(ucr get ldap/base)
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

############################################################
# Configure PAM
ln --symbolic --force "${MACHINE_SECRET_FILE}" /etc/pam_ldap.secret
univention-config-registry commit \
  /etc/pam_ldap.conf \
  /etc/pam.d/univention-management-console
sed -i '/pam_unix/d; /pam_krb5/d' /etc/pam.d/univention-management-console

if [[ -n "${SAML_SP_SERVER:-}" ]]; then
  # use the first given SAML scheme instead of the UCR template string
  SAML_SCHEMES=$(ucr get umc/saml/schemes)
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

# [EOF]
