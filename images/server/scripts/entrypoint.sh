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
# Initialize UCR from environment variables
python3 /env_to_ucr.py

############################################################
# Link certificates in place
PRIVATE_KEY_FILE=/run/secrets/private_key
CA_CERT_FILE=/run/secrets/ca_cert
CERT_PEM_FILE=/run/secrets/cert_pem

if [[ ! -f "${PRIVATE_KEY_FILE}" ]]; then
  echo "SSL private key is missing at ${PRIVATE_KEY_FILE}"
  exit 1
fi

if [[ ! -f "${CA_CERT_FILE}" ]]; then
  echo "SSL CA Certificate is missing at ${CA_CERT_FILE}"
  exit 1
fi

if [[ ! -f "${CERT_PEM_FILE}" ]]; then
  echo "SSL Site Certificate is missing at ${CERT_PEM_FILE}"
  exit 1
fi

CERT_DIR="/etc/univention/ssl/${hostname}.${domainname}"
CA_DIR="/etc/univention/ssl/ucsCA"

mkdir --parents "${CERT_DIR}"
mkdir --parents "${CA_DIR}"

ln --symbolic --force "${PRIVATE_KEY_FILE}" "${CERT_DIR}/private.key"
ln --symbolic --force "${CERT_PEM_FILE}" "${CERT_DIR}/cert.pem"
ln --symbolic --force "${CA_CERT_FILE}" "${CA_DIR}/CAcert.pem"


############################################################
# Load SAML metadata
SAML_METADATA_BASE=/usr/share/univention-management-console/saml/idp

if [[ -n "${SAML_METADATA_URL:-}" ]]; then
  if [[ -z "${SAML_METADATA_URL_INTERNAL:-}" ]]; then
    echo "SAML_METADATA_URL_INTERNAL is not set! Assuming it to equal SAML_METADATA_URL."
    SAML_METADATA_URL_INTERNAL=${SAML_METADATA_URL}
  fi

  SAML_HOST=`echo ${SAML_METADATA_URL} | awk -F/ '{print $3}'`
  SAML_METADATA_PATH="${SAML_METADATA_BASE}/${SAML_HOST}.xml"

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
          --header="Host: ${SAML_HOST}" \
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

  ucr set umc/saml/idp-server=${SAML_METADATA_URL}
fi

if [[ -n "${SAML_SP_SERVER:-}" ]]; then
  ucr set umc/saml/sp-server=${SAML_SP_SERVER}
  mkdir --parents "/etc/univention/ssl/${SAML_SP_SERVER}"
  ln --symbolic --force "${CERT_PEM_FILE}" "/etc/univention/ssl/${SAML_SP_SERVER}/cert.pem"
  ln --symbolic --force "${PRIVATE_KEY_FILE}" "/etc/univention/ssl/${SAML_SP_SERVER}/private.key"
fi

############################################################
# Store LDAP configuration
cat <<EOF > /etc/ldap/ldap.conf
# This file should be world readable but not world writable.

TLS_CACERT /etc/univention/ssl/ucsCA/CAcert.pem
TLS_REQCERT ${TLS_REQCERT:-demand}

URI ${LDAP_URI}

BASE ${LDAP_BASE}
EOF
chmod 0644 /etc/ldap/ldap.conf

touch /etc/machine.secret /etc/ldap.secret
chmod 0600 /etc/machine.secret /etc/ldap.secret
echo -n "${LDAP_ADMIN_PASSWORD}" > /etc/ldap.secret
echo -n "${LDAP_MACHINE_PASSWORD}" > /etc/machine.secret

echo -n "${LDAP_MACHINE_PASSWORD}" > /etc/pam_ldap.secret
chmod 0600 /etc/pam_ldap.secret
univention-config-registry commit \
  /etc/pam_ldap.conf \
  /etc/pam.d/univention-management-console
sed -i 's/password.*requisite.*pam_cracklib.so/password required  pam_cracklib.so/; /pam_unix/d; /pam_krb5/d' /etc/pam.d/univention-management-console

univention-config-registry commit \
  /var/www/univention/meta.json

univention-config-registry commit \
  /etc/univention/directory/reports/config.ini \
  /etc/univention/directory/reports/default/de_DE/header.rml \
  /etc/univention/directory/reports/default/de_DE/footer.rml \
  /etc/univention/directory/reports/default/en_US/header.rml \
  /etc/univention/directory/reports/default/en_US/footer.rml

exec /usr/sbin/univention-management-console-server "$@"
# [EOF]
