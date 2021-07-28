#!/bin/bash
set -euxo pipefail
umask 077

PID_PATH=/var/run/umc-web-server.pid

PRIVATE_KEY_FILE=/run/secrets/private_key
CA_CERT_FILE=/run/secrets/ca_cert
CERT_PEM_FILE=/run/secrets/cert_pem

CERT_DIR="/etc/univention/ssl/${HOSTNAME}.${DOMAINNAME}"
CA_DIR="/etc/univention/ssl/ucsCA"

DST_KEY_PATH="${CERT_DIR}/private.key"
DST_CERT_PATH="${CERT_DIR}/cert.pem"
DST_CA_PATH="${CA_DIR}/CAcert.pem"

SAML_METADATA_PATH="$(printf '%s%s' /usr/share/univention-management-console \
                                    /saml/idp/ucs-sso.example.org.xml)"

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

mkdir --parents "${CERT_DIR}"
mkdir --parents "${CA_DIR}"

cp -a "${PRIVATE_KEY_FILE}" "${DST_KEY_PATH}"
cp -a "${CA_CERT_FILE}" "${DST_CERT_PATH}"
cp -a "${CERT_PEM_FILE}" "${DST_CA_PATH}"

if [[ -f "${PID_PATH}" ]]; then
  echo "Removing stale pid ${PID_PATH}"
  rm "${PID_PATH}"
fi

if [[ -n "${SAML_METADATA_URL:-}" ]]; then
  result=1
  counter=3

  echo "Trying to fetch SAML metadata from ${SAML_METADATA_URL}"

  # 'Connection refused' is not retried by `wget --tries=X` hence the loop
  while [[ ${result} -gt 0 && ${counter} -gt 0 ]]; do
    {
        wget \
          --quiet \
          --timeout=3 \
          --tries=2 \
          --output-document="${SAML_METADATA_PATH}" \
          "${SAML_METADATA_URL}" \
        && result=0
    } || true

    counter=$((counter-1))
    sleep 3
  done

  if [[ ${result} -gt 0 ]]; then
    echo "Error: Failed to fetch saml_metadata from ${SAML_METADATA_URL}" >&2
    exit 255
  fi

  echo "Successfully set SAML metadata in ${SAML_METADATA_PATH}"
fi

exec /usr/sbin/univention-management-console-web-server "$@"

# [EOF]
