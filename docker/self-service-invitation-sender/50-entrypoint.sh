#!/bin/bash
set -euxo pipefail

# Trigger directory must be on volume shared with the listener
TRIGGER_DIR="/var/cache/univention-directory-listener/selfservice-invitation"
if [ ! -d "${TRIGGER_DIR}" ]; then
    echo "Directory does not exist: ${TRIGGER_DIR}"
    exit 1
fi
