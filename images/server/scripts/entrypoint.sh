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

PID_PATH=/var/run/umc-server.pid
SOCKET_PATH=/var/run/univention-management-console/server.socket

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

if [[ -f "${PID_PATH}" ]]; then
  echo "Removing stale pid ${PID_PATH}"
  rm "${PID_PATH}"
fi

if [[ -S "${SOCKET_PATH}" ]]; then
  echo "Removing stale socket file ${SOCKET_PATH}"
  rm "${SOCKET_PATH}"
fi

exec /usr/sbin/univention-management-console-server "$@"

exit 0

# [EOF]
