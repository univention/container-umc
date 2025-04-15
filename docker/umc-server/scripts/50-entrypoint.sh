#!/bin/bash
set -euxo pipefail
umask 077

# Univention Management Console Docker Entrypoint Script
# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2021-2025 Univention GmbH

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

  # remove advertised single logout service via SOAP
  sed --in-place --regexp-extended --expression \
    's#<md:SingleLogoutService[^>]+Binding="[^"]+bindings:SOAP"[^>]+>[^<]*</[^>]+>##' \
    "${SAML_METADATA_PATH}"

  chmod 0640 "${SAML_METADATA_PATH}"

  echo "Successfully set SAML metadata in ${SAML_METADATA_PATH}"

  mkdir --parents "/etc/univention/ssl/${SAML_SP_SERVER}"
  chmod 755 "/etc/univention/ssl/${SAML_SP_SERVER}"
  ln --symbolic --force "${CERT_PEM_FILE}" "/etc/univention/ssl/${SAML_SP_SERVER}/cert.pem"
  ln --symbolic --force "${PRIVATE_KEY_FILE}" "/etc/univention/ssl/${SAML_SP_SERVER}/private.key"
else
  echo "SAML Service Provider: disabled"
fi

############################################################
# Store SSSD configuration

if [[ ! -d /etc/sssd/conf.d ]]; then
  mkdir -p /etc/sssd/conf.d
fi

univention-config-registry commit /etc/sssd/sssd.conf
chown sssd:sssd /etc/sssd/sssd.conf
chmod 0700 /etc/sssd/sssd.conf

# Set LDAP machine authentication
MACHINE_SECRET_FILE=${MACHINE_SECRET_FILE:-/etc/machine.secret}
if [[ -f "${MACHINE_SECRET_FILE}" ]]; then
  echo "Using LDAP machine secret"
  cat <<EOF >> /etc/sssd/sssd.conf
ldap_default_authtok_type = password
ldap_default_authtok = $(cat "$MACHINE_SECRET_FILE")
EOF
else
  echo "No LDAP machine secret provided!"
fi

# NOTE: This is required for the UMC passwordreset module
# during the use-case of set recovery email. Otherwise, it will error with
# "Changing contact data failed"
LDAP_SECRET_FILE=${LDAP_SECRET_FILE:-/etc/ldap.secret}
if [[ -f "${LDAP_SECRET_FILE}" ]]; then
  echo "Using LDAP admin secret"
else
  echo "No LDAP admin secret provided!"
fi

############################################################
# Prepare LDAP TLS certificates and settings
UDM_STARTTLS=$(ucr get directory/manager/starttls)
if [[ -z "${UDM_STARTTLS}" ]]; then
  UDM_STARTTLS=2
fi

case "${UDM_STARTTLS}" in
  "2")
    TLS_REQCERT="demand"
    cat <<EOF >> /etc/sssd/sssd.conf
ldap_tls_reqcert = demand
ldap_id_use_start_tls = true
ldap_tls_cipher_suite = HIGH:MEDIUM:!aNULL:!MD5:!RC4
EOF
    ;;
  "1")
    TLS_REQCERT="allow"
    SASL_SECPROPS="none,minssf=0"
    cat <<EOF >> /etc/sssd/sssd.conf
ldap_tls_reqcert = allow
ldap_id_use_start_tls = true
ldap_sasl_minssf = 0
ldap_tls_cipher_suite = HIGH:MEDIUM:!aNULL:!MD5:!RC4
EOF
    ;;
  "0")
    TLS_REQCERT="never"
    SASL_SECPROPS="none,minssf=0"
    cat <<EOF >> /etc/sssd/sssd.conf
ldap_tls_reqcert = never
ldap_id_use_start_tls = false
ldap_auth_disable_tls_never_use_in_production = true
ldap_sasl_minssf = 0
EOF
    ;;
  *)
    echo "UCR variable 'directory/manager/starttls' must be one of: 0, 1, 2"
    exit 1
esac

if [[ "${TLS_REQCERT}" != "never" ]]; then
  CA_CERT_FILE=${CA_CERT_FILE:-/run/secrets/ca_cert}
  CA_DIR="/etc/univention/ssl/ucsCA"

  mkdir --parents "${CA_DIR}"
  ln --symbolic --force "${CA_CERT_FILE}" "${CA_DIR}/CAcert.pem"

  cat <<EOF >> /etc/sssd/sssd.conf
ldap_tls_cacert = ${CA_DIR}/CAcert.pem
EOF

fi

############################################################
# Store LDAP configuration
LDAP_HOST=$(ucr get ldap/master)
LDAP_PORT=$(ucr get ldap/master/port)
LDAP_BASE_DN=$(ucr get ldap/base)
if [[ ! -d /etc/ldap ]]; then
  mkdir /etc/ldap
fi
cat <<EOF > /etc/ldap/ldap.conf
# This file should be world readable but not world writable.

${CA_DIR:+TLS_CACERT /etc/univention/ssl/ucsCA/CAcert.pem}
TLS_REQCERT ${TLS_REQCERT}

URI ldap://${LDAP_HOST}:${LDAP_PORT}

BASE ${LDAP_BASE_DN}

${SASL_SECPROPS:+SASL_SECPROPS ${SASL_SECPROPS}}
EOF
chmod 0644 /etc/ldap/ldap.conf

############################################################
# Configure PAM

univention-config-registry commit /etc/pam.d/univention-management-console

# Disable kerberos and unix pam modules
sed -i '/pam_unix/d; /pam_krb5/d' /etc/pam.d/univention-management-console

if [[ -n "${SAML_SP_SERVER:-}" ]]; then
  # use the first given SAML scheme instead of the UCR template string
  SAML_SCHEMES=$(ucr get umc/saml/schemes)
  SCHEME=$(echo "${SAML_SCHEMES}" | cut -d, -f1)
  sed --in-place \
    --expression="s#trusted_sp=[[:alpha:]]*#${SCHEME}#" \
    "/etc/pam.d/univention-management-console"
fi

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
