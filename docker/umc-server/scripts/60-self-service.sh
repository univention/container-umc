#!/bin/bash
# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2023 Univention GmbH

set -euxo pipefail

# ensure that self-service database password is set
SELF_SERVICE_DB_SECRET_FILE="${SELF_SERVICE_DB_SECRET_FILE:-}"
if [ -z "${SELF_SERVICE_DB_SECRET_FILE:-}" ]; then
    echo "SELF_SERVICE_DB_SECRET_FILE not set"
    exit 1
elif [ ! -f "${SELF_SERVICE_DB_SECRET_FILE}" ]; then
    echo "SELF_SERVICE_DB_SECRET_FILE at ${SELF_SERVICE_DB_SECRET_FILE} not found."
    exit 1
fi

# if path to Memcached password file is set, the file must exist
if [ -n "${SELF_SERVICE_MEMCACHED_SECRET_FILE:-}" ] \
    && [ ! -f "${SELF_SERVICE_MEMCACHED_SECRET_FILE:-}" ]; then
    echo "SELF_SERVICE_MEMCACHED_SECRET_FILE at ${SELF_SERVICE_MEMCACHED_SECRET_FILE} not found."
    exit 1
fi
