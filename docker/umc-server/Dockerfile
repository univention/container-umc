# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2023-2026 Univention GmbH

############################################################
# Global variables

ARG UCS_BASE_IMAGE=gitregistry.knut.univention.de/univention/dev/projects/ucs-base-image/ucs-base-python
ARG UCS_BASE_IMAGE_TAG=5.2.7-build.20261119@sha256:2f9992daeb801d74219df5af5ac3aa6157bcbefc25105f78510365de881be9da
ARG SSSD_VERSION=2.10.2
ARG SSSD_SHA256=e8aa5e6b48ae465bea7064048715ce7e9c53b50ec6a9c69304f59e0d35be40ff
ARG SSSD_URL=https://github.com/SSSD/sssd/releases/download/${SSSD_VERSION}/sssd-${SSSD_VERSION}.tar.gz

############################################################
# Stage 0 - build sssd Debian package

FROM ${UCS_BASE_IMAGE}:${UCS_BASE_IMAGE_TAG} AS sssd
ARG SSSD_VERSION
ARG SSSD_SHA256
ARG SSSD_URL

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get --assume-yes --verbose-versions --no-install-recommends install ca-certificates

RUN groupadd -g 999 -r sssd \
  && useradd -r -g sssd -u 999 -d / -s /sbin/nologin -c "User for sssd" sssd

# NOTE: Dependencies needed for getting the source code and building (not included in the build-dep below)
RUN apt-get install --assume-yes --verbose-versions --allow-unauthenticated --no-install-recommends \
  wget=1.* \
  winbind=2:4.24.* \
  libcap-dev=1:2.66* \
  && cp /usr/lib/x86_64-linux-gnu/samba/libidmap-private-samba.so.0 /usr/lib/x86_64-linux-gnu/samba/libidmap-private-samba.so

COPY sssd/ /sssd/

# hadolint ignore=DL3003
RUN wget --progress=dot:giga "${SSSD_URL}" \
  # NOTE: Check for known checksum
  && echo "${SSSD_SHA256}  sssd-${SSSD_VERSION}.tar.gz" > "sssd-${SSSD_VERSION}.tar.gz.sha256" \
  && sha256sum -c "sssd-${SSSD_VERSION}.tar.gz.sha256" \
  && apt-get build-dep --assume-yes --allow-unauthenticated sssd \
  && tar -xvf "sssd-${SSSD_VERSION}.tar.gz" \
  && cd "sssd-${SSSD_VERSION}" \
  && for patch in /sssd/patches/*.patch; do patch -p1 < "${patch}"; done \
  && ./configure \
  --with-sssd-user=sssd \
  --disable-krb5-locator-plugin \
  --disable-pac-responder \
  --disable-cifs-idmap-plugin \
  --without-python2-bindings \
  --without-autofs \
  --without-samba \
  --without-nfsv4-idmapd-plugin \
  --without-libwbclient \
  --without-libnl \
  --disable-nls \
  --disable-rpath \
  --without-oidc-child \
  && make -j"$(nproc)" \
  && make install DESTDIR=/sssd-root \
  && rm -f /sssd-root/usr/local/lib/sssd/modules/sssd_krb5_idp_plugin.so \
  && cd / \
  && /sssd/build-deb.sh /sssd-root "${SSSD_VERSION}" /sssd.deb \
  && rm -rf "/sssd-${SSSD_VERSION}"* /sssd-root

############################################################
# Stage 1

FROM ${UCS_BASE_IMAGE}:${UCS_BASE_IMAGE_TAG} AS build

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

WORKDIR /apt

############################################################
# Install scripts and configs for dpkg

COPY scripts/fake.sh /usr/local/bin/systemctl
COPY scripts/fake.sh /usr/local/bin/a2dissite
COPY scripts/fake.sh /usr/local/bin/call_joinscript
COPY scripts/fake.sh /usr/local/bin/create_logfile
COPY scripts/fake.sh /usr/local/bin/stop_udm_cli_server
COPY scripts/fake.sh /usr/local/bin/umc_frontend_new_hash
COPY scripts/fake.sh /usr/sbin/univention-management-console-acls
COPY scripts/fake-uv-lib.sh /usr/local/bin/fake-uv-lib.sh

############################################################
# Install univention-management-console-server and required dependencies

RUN \
  # For apt-get download sandbox
  chown _apt /apt && \
  mkdir /var/log/univention/ && \
  mkdir -p /usr/share/locale/de/LC_MESSAGES/ && \
  # install Univention bash helper functions dependency
  DEBIAN_FRONTEND=noninteractive \
  apt-get --assume-yes --verbose-versions --no-install-recommends install \
  shell-univention-lib \
  && \
  # we do not need the many bash helper-functions here
  cp /usr/local/bin/fake-uv-lib.sh /usr/share/univention-lib/all.sh && \
  cp /usr/local/bin/fake-uv-lib.sh /usr/share/univention-lib/base.sh && \
  cp /usr/local/bin/fake-uv-lib.sh /usr/share/univention-lib/join.sh && \
  cp /usr/local/bin/fake-uv-lib.sh /usr/share/univention-lib/umc.sh && \
  # install Python dependencies
  DEBIAN_FRONTEND=noninteractive \
  apt-get --assume-yes --verbose-versions --no-install-recommends install \
  --option Dpkg::Options::="--force-confold" \
  # used by the final stage to apply patches/
  patch \
  python3 \
  python3-distutils \
  # for /usr/sbin/univention-config-registry
  python3-lazy-object-proxy \
  # the python3-univention-debug postinst uses py3compile
  python3-minimal \
  # for /usr/sbin/univention-config-registry
  python3-six \
  && \
  apt-get download \
  # UV package
  libunivention-config0 \
  libunivention-debug1 \
  libunivention-license0 \
  libunivention-policy0 \
  # use UCS-repo because it is not yet in Debian/stable (just bullseye)
  python3-m2crypto \
  python3-notifier \
  python3-pam \
  python3-trml2pdf \
  python3-univention \
  # for $PY_LIBS/univention/admindiary/{__init__,client,events}.py
  python3-univention-admin-diary \
  python3-univention-authorization \
  python3-univention-config-registry \
  # for univention.logging
  python3-univention-debug \
  python3-univention-debhelper \
  # for /usr/share/locale/de/LC_MESSAGES/univention-admin*.mo
  python3-univention-directory-manager \
  python3-univention-directory-manager-rest-client \
  python3-univention-directory-reports \
  python3-univention-heimdal \
  python3-univention-lib \
  python3-univention-lib-icap \
  python3-univention-license \
  python3-univention-management-console \
  # for /usr/sbin/univention-config-registry
  univention-config \
  univention-directory-reports \
  univention-heimdal-common \
  univention-management-console-module-udm \
  univention-management-console-server \
  univention-pam \
  # for the self-service
  univention-self-service-passwordreset-umc \
  && \
  echo 'path-exclude /usr/sbin/univention-management-console-acls' \
    >> /etc/dpkg/dpkg.cfg.d/univention && \
  echo 'path-include /usr/share/doc/univention-management-console-server/changelog.gz' \
    >> /etc/dpkg/dpkg.cfg.d/univention && \
  echo 'path-include /usr/share/locale/de/LC_MESSAGES/univention-*.mo' \
    >> /etc/dpkg/dpkg.cfg.d/univention && \
  DEBIAN_FRONTEND=noninteractive \
  dpkg --install --force-depends /apt/* && \
  rm -rf /apt/ && \
  awk \
  '/^Package: univention-management-console-server$/{ while(!/^Version: /){getline} print $2 }' \
  /var/lib/dpkg/status > /version

WORKDIR /apt
RUN \
  # For apt-get download sandbox
  chown _apt /apt && \
  apt-get download \
  univention-management-console-web-server \
  univention-management-console-frontend \
  && \
  for i in /apt/*.deb; do dpkg --extract "$i" /; done && \
  rm -rf /apt/

# Record all installed Debian packages owning at least one non-directory entry
# below /usr/lib/python3/dist-packages as "<package>=<version>", one per line,
# plus the packages listed explicitly below, which ship no Python modules but
# are needed by them or by the UMC server.
# The final stage installs exactly these versions via dpkg, so that SBOM
# scanners attribute the files to their Debian packages.
# hadolint ignore=SC2016
RUN \
  # the loop below would trace every single file
  set +x && \
  { \
    for list in /var/lib/dpkg/info/*.list; do \
      pkg="$(basename "${list}" .list)"; \
      # "|| true": grep fails without matches or on SIGPIPE after "break"
      { grep '^/usr/lib/python3/dist-packages/.' "${list}" || true; } | \
      while IFS= read -r path; do \
        if [ -L "${path}" ] || [ ! -d "${path}" ]; then echo "${pkg}"; break; fi; \
      done; \
    done; \
    # shared libraries linked by the Python C extensions
    echo libunivention-config0; \
    echo libunivention-license0; \
    echo libunivention-policy0; \
    # /usr/sbin/univention-management-console-{server,module}
    echo univention-management-console-server; \
  } | \
  xargs --no-run-if-empty \
  dpkg-query --show --showformat='${db:Status-Abbrev} ${Package}=${Version}\n' | \
  awk '$1 == "ii" { print $2 }' | \
  LC_ALL=C sort --unique > /umc-packages.list && \
  test -s /umc-packages.list && \
  cat /umc-packages.list

############################################################
# Start final stage

FROM ${UCS_BASE_IMAGE}:${UCS_BASE_IMAGE_TAG} AS final

ARG PY_LIBS="/usr/lib/python3/dist-packages"

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

WORKDIR /

RUN --mount=type=bind,from=sssd,source=/sssd.deb,target=/tmp/sssd.deb \
  groupadd -g 999 -r sssd && \
  useradd -r -g sssd -u 999 -d / -s /sbin/nologin -c "User for sssd" sssd && \
  apt-get --assume-yes --verbose-versions --no-install-recommends install \
  /tmp/sssd.deb \
  # for $PY_LIBS/univention/management/console/message.py
  # calling $PY_LIBS/univention/uldap.py
  cy2-saml \
  libc-bin \
  # for $PY_LIBS/univention/admin/password.py
  libhdb9-heimdal \
  # for $PY_LIBS/univention/admin/password.py
  libkrb5-26-heimdal \
  libpam-oauthbearer \
  # for $PY_LIBS/univention/management/console/pam.py
  libpam-pwquality \
  libpam0g \
  # for pylibmc (SASL authentication with memcached)
  libsasl2-modules \
  libsasl2-modules-oauthbearer \
  locales \
  # for generating stub SAML certificates
  openssl \
  pam-saml \
  # for $PY_LIBS/univention/admin/handlers/settings/
  python3-apt \
  # for $PY_LIBS/univention/admin/password.py
  python3-bcrypt \
  # for /usr/sbin/univention-management-console-web-server
  python3-cherrypy3 \
  # for $PY_LIBS/univention/password.py
  python3-cracklib \
  # for ...
  python3-cryptography \
  # for /usr/sbin/univention-management-console-server
  python3-daemon \
  # for $PY_LIBS/univention/admin/syntax.py
  python3-dateutil \
  # for /usr/sbin/univention-management-console-web-server
  python3-defusedxml \
  # for $PY_LIBS/univention/admin/syntax.py
  python3-email-validator \
  # for $PY_LIBS/univention/management/console/oidc.py
  python3-jwt \
  # for $PY_LIBS/univention/config_registry/
  python3-lazy-object-proxy \
  # for $PY_LIBS/univention/management/console/protocol/session.py
  # the debian-buster version would cause a segfault.
  python3-ldap \
  # for $PY_LIBS/univention/lib/umc_module.py
  python3-magic \
  # for $PY_LIBS/univention/management/console/protocol/server.py
  python3-openssl \
  # for $PY_LIBS/univention/admin/password.py
  python3-passlib \
  # for $PY_LIBS/univention/admin/syntax.py
  python3-pil \
  # for $PY_LIBS/univention/management/console/locales.py
  python3-polib \
  # for $PY_LIBS/univention/management/console/modules/passwordreset/tokendb.py
  # NOTE: This is will attempt to write to /var/run/postgresql/.s.PGSQL.5432 and fail
  python3-psycopg2 \
  # for ...
  python3-pycurl \
  # for $PY_LIBS/univention/management/console/modules/passwordreset/__init__.py
  python3-pylibmc \
  # for /usr/sbin/univention-management-console-web-server
  python3-pysaml2 \
  # for python3-trml2pdf
  python3-reportlab \
  # for $PY_LIBS/univention/management/console/server.py
  python3-sdnotify \
  # for ...
  python3-setproctitle \
  # for $PY_LIBS/univention/config_registry/
  python3-six \
  # for /usr/sbin/univention-management-console-server
  python3-sqlalchemy \
  # for $PY_LIBS/univention/management/console/protocol/server.py
  python3-tornado \
  # for $PY_LIBS/univention/management/console/protocol/modserver.py
  python3-tzlocal \
  # for $PY_LIBS/univention/admin/__init__.py
  python3-unidecode \
  # for $PY_LIBS/univention/admin/rest/client/__init__.py
  python3-uritemplate \
  # for the entrypoint.sh script
  wget && \
  #
  # Install regular dependencies
  #
  # NOTE: Ongoing simplification. The current build approach is difficult to
  # maintain, because dependency changes are only reflected in the Debian packages
  # and would have to be replicated here.
  #
  # We aim to switch to use regular base packages and where needed adjust the base
  # package dependencies.
  #
  apt-get --assume-yes --verbose-versions --no-install-recommends install \
    python3-univention-debug \
    univention-config \
  && rm -rf /var/lib/apt/lists/* && \
  #
  # Enable the sss NSS module, like the postinst scripts of Debian's sssd
  # packages do. The self-built sssd package has no maintainer scripts, and
  # without this entry getent and id do not see the LDAP users and groups.
  #
  sed -i -E '/^(passwd|group|shadow|services|netgroup|sudoers):/ { /\bsss\b/! s/$/ sss/ }' /etc/nsswitch.conf && \
  { grep -qE '^sudoers:' /etc/nsswitch.conf || echo 'sudoers:        files sss' >> /etc/nsswitch.conf; } && \
  { grep -qE '^automount:' /etc/nsswitch.conf || echo 'automount:      sss' >> /etc/nsswitch.conf; }


############################################################
# Install the Debian packages recorded in the build stage

# Install the packages in the exact versions recorded in the build stage,
# instead of copying their files.
# The build stage's /usr/local/bin provides the fake commands called by the
# maintainer scripts, its /usr/share/univention-lib the Univention shell
# library (with all.sh, base.sh, join.sh and umc.sh replaced by fake-uv-lib.sh)
# and its /var/lib/apt/lists the package indices matching the recorded versions.
# Afterwards patches/ is applied on top of the pristine files from the Debian
# packages, using the patch tool from the build stage.
WORKDIR /apt

# hadolint ignore=SC2016
RUN \
  --mount=type=bind,from=build,source=/usr/local/bin,target=/usr/local/bin \
  --mount=type=bind,from=build,source=/usr/share/univention-lib,target=/usr/share/univention-lib \
  --mount=type=bind,from=build,source=/umc-packages.list,target=/umc-packages.list \
  --mount=type=bind,from=build,source=/var/lib/apt/lists,target=/var/lib/apt/lists,rw \
  --mount=type=bind,from=build,source=/usr/bin/patch,target=/usr/bin/patch \
  --mount=type=bind,source=patches,target=/patches \
  chown _apt /apt && \
  mkdir /var/log/univention/ && \
  # skip packages which are already installed in exactly this version
  while IFS='=' read -r pkg version; do \
    # "|| true": dpkg-query fails for packages which are not installed
    installed="$(dpkg-query --show --showformat='${db:Status-Abbrev}${Version}' "${pkg}" 2>/dev/null || true)"; \
    if [ "${installed}" != "ii ${version}" ]; then \
      echo "${pkg}=${version}"; \
    fi; \
  done < /umc-packages.list > umc-packages.download && \
  # the maintainer scripts call it, the real one is excluded below;
  # /usr/local/bin/systemctl is a copy of fake.sh
  cp /usr/local/bin/systemctl /usr/sbin/univention-management-console-acls && \
  # an empty list means everything is installed already, and "./*.deb" would
  # stay a literal string without any downloaded file
  if [ -s umc-packages.download ]; then \
    xargs apt-get download < umc-packages.download && \
    # the --path-include options override the path-exclude rules of the base
    # image in /etc/dpkg/dpkg.cfg.d/, as in the build stage:
    # the changelog is read by "umc-get info", the .mo files are the German
    # translations of UDM, UMC and the Univention libraries
    DEBIAN_FRONTEND=noninteractive \
    dpkg --install --force-depends \
    --path-exclude=/usr/sbin/univention-management-console-acls \
    --path-exclude='/usr/share/univention-management-console-frontend/*' \
    --path-include=/usr/share/doc/univention-management-console-server/changelog.gz \
    --path-include='/usr/share/locale/de/LC_MESSAGES/univention-*.mo' \
    ./*.deb; \
  fi && \
  rm /usr/sbin/univention-management-console-acls && \
  UMC_MODULES="${PY_LIBS}/univention/management/console/modules" && \
  patch --no-backup-if-mismatch -p 4 -d "${PY_LIBS}" \
    -i /patches/0001-set-password-without-kerberos.patch && \
  patch --no-backup-if-mismatch -p 4 -d "${PY_LIBS}" \
    -i /patches/0002-disable-suffixed_cookie_name.patch && \
  patch --no-backup-if-mismatch -p 5 -d "${UMC_MODULES}" \
    -i /patches/0003-support-un-authenticated-memcached.patch && \
  patch --no-backup-if-mismatch -p 5 -d "${UMC_MODULES}" \
    -i /patches/0004-provide-domainname-to-email-templates.patch && \
  patch --no-backup-if-mismatch -p 5 -d "${UMC_MODULES}" \
    -i /patches/0005-smtp-authentication-for-self-service-emails.patch && \
  patch --no-backup-if-mismatch -p 4 -d "${PY_LIBS}" \
    -i /patches/0006-remove-UDM-import.patch && \
  patch --no-backup-if-mismatch -p 4 -d "${PY_LIBS}" \
    -i /patches/0007-replace-PAM-login-with-UDM-login-for-password-change.patch && \
  patch --no-backup-if-mismatch -p 5 -d "${UMC_MODULES}" \
    -i /patches/0008-allow-to-set-individual-attributes-to-readonly-in-pa.patch && \
  patch --no-backup-if-mismatch -p 4 -d /usr/sbin \
    -i /patches/0009-remove-is-root-check.patch && \
  patch --no-backup-if-mismatch -p 4 -d "${PY_LIBS}" \
    -i /patches/0010-fix-disabling-structured-logging-restores-original-f.patch && \
  # fail the build if a maintainer script above rewrote /etc/nsswitch.conf
  # and dropped the sss entries added after the sssd installation
  grep -qE '^passwd:.*\bsss\b' /etc/nsswitch.conf && \
  grep -qE '^group:.*\bsss\b' /etc/nsswitch.conf && \
  rm -rf /apt/

WORKDIR /

############################################################
# Copy files from other stages

RUN mkdir /usr/share/doc/univention-management-console-web-server/

COPY --from=build \
  /etc/univention/templates/info/univention-pam.info \
  /etc/univention/templates/info/univention-pam.info

COPY --from=build \
  /etc/univention/templates/files/etc/sssd/sssd.conf \
  /etc/univention/templates/files/etc/sssd/sssd.conf

COPY --from=build \
  /etc/univention/templates/info/univention-heimdal-common.info \
  /etc/univention/templates/info/univention-heimdal-common.info

COPY --from=build \
  /etc/univention/templates/files/etc/krb5.conf \
  /etc/univention/templates/files/etc/krb5.conf

COPY --from=build \
  /etc/univention/templates/info/univention-management-console-web-server.info \
  /etc/univention/templates/info/
# Read by pam_oauthbearer in the UMC PAM stack
COPY --from=build \
  /etc/univention/templates/files/etc/ldap/sasl2/slapd.conf \
  /etc/univention/templates/files/etc/ldap/sasl2/slapd.conf

# stub file for SAML IdP setup (handled by entrypoint.sh)
# TODO: This calls UDM and creates saml/serviceprovider entries. Do we need them?
RUN \
  mkdir /etc/univention/templates/modules && \
  touch /etc/univention/templates/modules/setup_saml_sp.py

# stub files referenced by pam*
RUN \
  mkdir \
  /etc/univention/templates/files/etc/pam.d/common-auth.d \
  /etc/univention/templates/files/etc/pam.d/common-session.d \
  && \
  touch \
  /etc/univention/templates/files/etc/pam.d/common-session.d/10univention-pam_common \
  /etc/univention/templates/files/etc/pam.d/common-auth.d/10univention-pam_header \
  /etc/univention/templates/files/etc/pam.d/common-auth.d/30univention-pam_local \
  /etc/univention/templates/files/etc/pam.d/common-auth.d/50univention-pam_general \
  /etc/univention/templates/files/etc/pam.d/common-auth.d/70univention-pam_env

# available reports
COPY --from=build \
  /etc/univention/directory/reports/ \
  /etc/univention/directory/reports/
COPY --from=build \
  /etc/univention/templates/files/etc/univention/directory/reports/ \
  /etc/univention/templates/files/etc/univention/directory/reports/
COPY --from=build \
  /etc/univention/templates/info/univention-directory-reports.info \
  /etc/univention/templates/info/univention-directory-reports.info
COPY --from=build \
  /usr/share/univention-directory-reports/ \
  /usr/share/univention-directory-reports/
COPY --from=build \
  /usr/share/locale/de/LC_MESSAGES/univention-directory-reports.mo \
  /usr/share/locale/de/LC_MESSAGES/

COPY --from=build \
  /usr/share/univention-management-console/saml/sp.py \
  /usr/share/univention-management-console/saml/sp.py

COPY --from=build \
  /usr/share/univention-management-console-frontend/error.html \
  /usr/share/univention-management-console-frontend/error.html

COPY --from=build \
  /etc/univention/*.conf \
  /etc/univention/

COPY --from=build \
  /version \
  /version

############################################################
# Copy Docker-specific files

COPY scripts/50-entrypoint.sh \
  scripts/60-self-service.sh \
  /entrypoint.d/

############################################################
# Define runtime

# build all locales
RUN echo -en 'en_US.UTF-8 UTF-8\nde_DE.UTF-8 UTF-8\n' >> /etc/locale.gen && \
  localedef -i de_DE -c -f UTF-8 -A /usr/share/locale/locale.alias de_DE.UTF-8 && \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
  # Create directory for SAML IDP xml
  mkdir -p /usr/share/univention-management-console/saml/idp && \
  # Generate stub SAML certificates
  mkdir -p /opt/univention/ssl-stub && \
  openssl req -x509 -newkey rsa:2048 -keyout /opt/univention/ssl-stub/private.key \
    -out /opt/univention/ssl-stub/cert.pem -days 3650 -nodes \
    -subj "/CN=stub.example.com/O=Stub Certificate" && \
  chown -R sssd:sssd /opt/univention/ssl-stub && \
  chmod 640 /opt/univention/ssl-stub/private.key && \
  # Read by udm_ldap.py UMC module
  mkdir -p /var/lib/univention-appcenter/attributes && \
  echo '{"en_US": {}, "de_DE": {}}' > /var/lib/univention-appcenter/attributes/mapping.json

############################################################
# Set permissions

RUN \
  mkdir -p \
    /etc/ldap \
    /etc/krb5 \
    /etc/sssd \
    /etc/univention/ssl \
    /var/www/univention && \
  chown -R sssd:sssd \
  /usr/sbin/univention-management-console-server \
  /usr/sbin/univention-management-console-module \
  /usr/share/univention-management-console \
  /var/cache/univention-management-console \
  /var/log/univention \
  /etc/ldap \
  /etc/krb5 \
  /etc/pam.d \
  /etc/univention \
  /etc/sssd \
  /usr/lib/python3/dist-packages/univention \
  /usr/share/locale/de/LC_MESSAGES \
  /var/lib/univention-appcenter \
  /var/cache/univention-config \
  /var/www/univention \
  && chmod -R 755 \
  /entrypoint.d \
  /usr/sbin/univention-management-console-server \
  /usr/sbin/univention-management-console-module \
  /usr/share/univention-management-console \
  /var/cache/univention-management-console \
  /var/log/univention \
  /etc/univention \
  /etc/sssd \
  /usr/lib/python3/dist-packages/univention \
  /usr/share/locale/de/LC_MESSAGES \
  /var/lib/univention-appcenter \
  /var/cache/univention-config

USER sssd

CMD ["/usr/sbin/univention-management-console-server", \
  "--no-daemonize-module-processes", \
  "--log-file", "stdout" \
  ]

# [EOF]
