#!/bin/bash
# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2025 Univention GmbH

set -euo pipefail

groupadd -g 999 -r sssd \
  && useradd -r -g sssd -u 999 -d / -s /sbin/nologin -c "User for sssd" sssd

TARGET_DIR="${1:-/}"

ARCHIVE_LINE=$(awk '/^__ARCHIVE_BELOW__/ {print NR + 1; exit 0; }' "$0")
tail -n +"$ARCHIVE_LINE" "$0" | tar xvz -C "$TARGET_DIR"

cp -v /usr/local/lib/security/pam_sss.so /usr/lib/x86_64-linux-gnu/security/pam_sss.so

# NOTE: If this file is not removed, sssd will error because of a different
# version of the library (2.8 but it wants 2.10)
rm /usr/lib/x86_64-linux-gnu/samba/ldb/memberof.la

apt-get --assume-yes --verbose-versions --no-install-recommends install \
  libsss-certmap0=2.8.* \
  libsss-sudo=2.8.* \
  libsss-idmap0=2.8.* \
  libsss-nss-idmap0=2.8.* \
  sssd-ldap=2.8.*

exit 0
# shellcheck disable=SC2317
__ARCHIVE_BELOW__
