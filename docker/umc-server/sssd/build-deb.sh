#!/bin/bash
# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2026 Univention GmbH

# Usage: build-deb.sh <install-root> <sssd-version> <output-file>

set -euxo pipefail

ROOT="$1"
VERSION="$2"
OUTPUT="$3"

REVISION="0nubus1"
ARCH="$(dpkg --print-architecture)"
MULTIARCH="$(dpkg-architecture --query DEB_HOST_MULTIARCH)"

REPLACED_PACKAGES="libnss-sss, libpam-sss, libsss-certmap0, libsss-idmap0, libsss-nss-idmap0, libsss-sudo, python3-sss, sssd-common, sssd-krb5-common, sssd-ldap"
PROVIDED_VERSION="(= ${VERSION}-${REVISION})"
PROVIDES="${REPLACED_PACKAGES//,/ ${PROVIDED_VERSION},} ${PROVIDED_VERSION}"

find "${ROOT}" -name '*.la' -delete
find "${ROOT}" -type d -exec chmod g-s {} +

install -D --mode=0644 \
  "${ROOT}/usr/local/lib/security/pam_sss.so" \
  "${ROOT}/usr/lib/${MULTIARCH}/security/pam_sss.so"

mkdir -p "${ROOT}/DEBIAN"
echo 'activate-noawait ldconfig' >"${ROOT}/DEBIAN/triggers"
while IFS= read -r -d '' library; do
  soname="$(objdump -p "${library}" | sed -n 's/^ *SONAME *//p')"
  if [[ "${soname}" =~ ^(.+)\.so\.([0-9]+)$ ]]; then
    echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]} sssd (>= ${VERSION}-${REVISION})"
  fi
done < <(find "${ROOT}/usr/local/lib" -maxdepth 1 -type f -name '*.so.*' -print0) |
  sort -u >"${ROOT}/DEBIAN/shlibs"

WORKDIR="$(mktemp -d)"
mkdir "${WORKDIR}/debian"
printf 'Source: sssd\n\nPackage: sssd\nArchitecture: any\n' >"${WORKDIR}/debian/control"

ELF_FILES=()
while IFS= read -r -d '' file; do
  if cmp --silent --bytes=4 "${file}" <(printf '\177ELF'); then
    ELF_FILES+=("${file}")
  fi
done < <(find "${ROOT}" -type f -print0)

SHLIBS_DEPENDS="$(
  cd "${WORKDIR}" &&
    dpkg-shlibdeps -O \
      -xsssd \
      -S"${ROOT}" \
      -l"${ROOT}/usr/local/lib" \
      -l"${ROOT}/usr/local/lib/sssd" \
      "${ELF_FILES[@]}" |
    sed -n 's/^shlibs:Depends=//p'
)"
rm -rf "${WORKDIR}"

cat >"${ROOT}/DEBIAN/control" <<EOF
Package: sssd
Source: sssd
Version: ${VERSION}-${REVISION}
Architecture: ${ARCH}
Maintainer: Univention GmbH <packages@univention.de>
Section: admin
Priority: optional
Homepage: https://sssd.io
Depends: python3, ${SHLIBS_DEPENDS}
Provides: ${PROVIDES}
Conflicts: ${REPLACED_PACKAGES}
Replaces: ${REPLACED_PACKAGES}
Description: System Security Services Daemon (Nubus build)
 SSSD ${VERSION} built from the upstream release so that it runs as the
 unprivileged "sssd" user in the umc-server container.
EOF

dpkg-deb --build "${ROOT}" "${OUTPUT}"
