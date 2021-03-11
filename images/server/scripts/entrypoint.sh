#!/bin/bash
# -*- coding: utf-8 -*-
set -euxo pipefail

#
# Univention Management Console Docker Entrypoint Script
#
# Copyright 2021 Univention GmbH
#
# https://www.univention.de/
#
# License: Public Domain (no inventive step)
#

PRIVATE_KEY_FILE=/run/secrets/private_key
CA_CERT_FILE=/run/secrets/ca_cert
CERT_PEM_FILE=/run/secrets/cert_pem

CERT_DIR="/etc/univention/ssl/${HOSTNAME}.${DOMAINNAME}"
CA_DIR="/etc/univention/ssl/ucsCA"

DST_KEY_PATH="${CERT_DIR}/private.key"
DST_CERT_PATH="${CERT_DIR}/cert.pem"
DST_CA_PATH="${CA_DIR}/CAcert.pem"

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

/usr/sbin/univention-management-console-server "$@"

exit 0

# [EOF]
