#!/bin/bash
# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2023-2025 Univention GmbH

set -euxo pipefail

# database password must be set
if [ -z "${SELF_SERVICE_DB_SECRET:-}" ]; then
    echo "SELF_SERVICE_DB_SECRET is not set!"
    exit 1
fi
