# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2023 Univention GmbH

############################################################
# Global variables

ARG UCS_BASE_IMAGE_TAG=0.13.1-post-main-build-2024-09-09
ARG UCS_BASE_IMAGE=gitregistry.knut.univention.de/univention/components/ucs-base-image/ucs-base-520

############################################################
# Start first stage

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
      shell-univention-lib=11.* \
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
      python3=3.11.* \
      python3-distutils=3.11.* \
      patch=2.* \
      # for /usr/sbin/univention-config-registry
      python3-lazy-object-proxy=1.9.* \
      # the python3-univention-debug postinst uses py3compile
      python3-minimal=3.11.* \
      # for /usr/sbin/univention-config-registry
      python3-six=1.16.* \
      && \
  apt-get download \
    # UV package
    libunivention-config0=17.* \
    libunivention-debug1=14.* \
    libunivention-license0=13.* \
    libunivention-policy0=13.* \
    # for /usr/share/locale/de/LC_MESSAGES/univention-admin*.mo
    python3-univention-directory-manager=17.* \
    python3-notifier=0.9.* \
    # use UCS-repo because it is not yet in Debian/stable (just bullseye)
    python3-m2crypto=0.38.* \
    python3-pam=0.4.2-* \
    python3-trml2pdf=1.2-* \
    python3-univention=15.* \
    # for $PY_LIBS/univention/admindiary/__init__.py
    python3-univention-admin-diary=4.* \
    python3-univention-config-registry=17.* \
    # for univention.logging
    python3-univention-debug=14.* \
    python3-univention-directory-manager=17.* \
    python3-univention-directory-manager-rest-client=12.* \
    python3-univention-directory-reports=14.* \
    python3-univention-heimdal=12.* \
    python3-univention-lib=11.* \
    python3-univention-license=13.* \
    python3-univention-management-console=14.* \
    python3-univention-debhelper=4.* \
    # for $PY_LIBS/univention/admindiary/client.py and
    # $PY_LIBS/univention/admindiary/events.py
    univention-admin-diary-client=4.* \
    # for /usr/sbin/univention-config-registry
    univention-config=17.* \
    univention-directory-reports=14.* \
    univention-management-console-module-udm=12.* \
    univention-management-console-server=14.* \
    univention-pam=15.* \
    # for the self-service
    univention-self-service-passwordreset-umc=7.* \
    && \
  echo 'path-exclude /usr/sbin/univention-management-console-acls' >> /etc/dpkg/dpkg.cfg.d/univention && \
  echo 'path-include /usr/share/doc/univention-management-console-server/changelog.gz' >> /etc/dpkg/dpkg.cfg.d/univention && \
  echo 'path-include /usr/share/locale/de/LC_MESSAGES/univention-*.mo' >> /etc/dpkg/dpkg.cfg.d/univention && \
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
    univention-management-console-web-server=14.* \
    univention-management-console-frontend=14.* \
    && \
  for i in /apt/*.deb; do dpkg --extract "$i" /; done && \
  rm -rf /apt/

COPY patches/*.patch /

RUN \
  patch -p 3 -d /usr/lib/python3/dist-packages/ -i /0001-set-password-without-kerberos.patch && \
  patch -p 3 -d /usr/lib/python3/dist-packages/ -i /0002-disable-license-check.patch && \
  patch -p 3 -d /usr/lib/python3/dist-packages/ -i /0003-disable-suffixed_cookie_name.patch && \
  patch -p 4 -d /usr/lib/python3/dist-packages/univention/management/console/modules -i /0004-support-un-authenticated-memcached.patch && \
  patch -p 4 -d /usr/lib/python3/dist-packages/univention/management/console/modules -i /0005-provide-domainname-to-email-templates.patch && \
  patch -p 4 -d /usr/lib/python3/dist-packages/univention/management/console/modules -i /0006-smtp-authentication-for-self-service-emails.patch && \
  patch -p 3 -d /usr/lib/python3/dist-packages/ -i /0007-remove-UDM-import.patch && \
  patch -p 3 -d /usr/lib/python3/dist-packages/ -i /0008-enforce-JPEG-conversion-for-all-profile-pictures.patch && \
  rm -v /*.patch

############################################################
# Start second stage

FROM ${UCS_BASE_IMAGE}:${UCS_BASE_IMAGE_TAG} AS final

ARG SRC_PY_LIBS="/usr/lib/python3/dist-packages"
ARG DST_PY_LIBS="/usr/lib/python3/dist-packages"

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

WORKDIR /

RUN \
  apt-get --assume-yes --verbose-versions --no-install-recommends install \
    libc-bin=2.36-* \
    locales=2.36-* \
    # for $PY_LIBS/univention/admin/password.py
    libhdb9-heimdal=7.8.* \
    # for $PY_LIBS/univention/admin/password.py
    libkrb5-26-heimdal=7.8.* \
    libpam0g=1.5.* \
    libpam-sss=2.8.* \
    pam-saml=3.0.* \
    # for $PY_LIBS/univention/management/console/pam.py
    libpam-pwquality=1.4.* \
    # for $PY_LIBS/univention/management/console/protocol/session.py
    # the debian-buster version would cause a segfault.
    python3-ldap=3.4.* \
    # for $PY_LIBS/univention/management/console/message.py
    # calling $PY_LIBS/univention/uldap.py
    cy2-saml=3.0.* \
    # for pylibmc (SASL authentication with memcached)
    libsasl2-modules=2.1.* \
    # for $PY_LIBS/univention/admin/password.py
    python3-bcrypt=3.2.* \
    # for /usr/sbin/univention-management-console-server
    python3-daemon=2.3.* \
    # for $PY_LIBS/univention/admin/syntax.py
    python3-dateutil=2.8.* \
    # for /usr/sbin/univention-management-console-web-server
    python3-defusedxml=0.7.* \
    # for $PY_LIBS/univention/lib/umc_module.py
    python3-magic=2:* \
    # for $PY_LIBS/univention/management/console/protocol/server.py
    python3-openssl=23.* \
    # for $PY_LIBS/univention/admin/syntax.py
    python3-pil=9.4.* \
    # for $PY_LIBS/univention/management/console/locales.py
    python3-polib=1.1.* \
    # for $PY_LIBS/univention/management/console/protocol/server.py
    python3-tornado=6.2.* \
    # for $PY_LIBS/univention/config_registry/
    python3-lazy-object-proxy=1.9.* \
    python3-six=1.16.* \
    # for $PY_LIBS/univention/password.py
    python3-cracklib=2.* \
    # for $PY_LIBS/univention/admin/syntax.py
    python3-email-validator=1.3.* \
    # for ...
    python3-cryptography=38.* \
    # for $PY_LIBS/univention/admin/handlers/settings/
    python3-apt=2.6.* \
    # for python3-trml2pdf
    python3-reportlab=3.6.* \
    # for $PY_LIBS/univention/admin/password.py
    python3-passlib=1.7.* \
    # for ...
    python3-pycurl=7.* \
    # for /usr/sbin/univention-management-console-server
    python3-sqlalchemy=1.4.* \
    # for /usr/sbin/univention-management-console-web-server
    python3-cherrypy3=18.* \
    python3-pysaml2=7.0.* \
    # for $PY_LIBS/univention/management/console/server.py
    python3-sdnotify=0.* \
    # for ...
    python3-setproctitle=1.* \
    # for ...
    python3-tornado=6.* \
    # for $PY_LIBS/univention/management/console/protocol/modserver.py
    python3-tzlocal=4.* \
    # for $PY_LIBS/univention/admin/__init__.py
    python3-unidecode=1.3.* \
    # for $PY_LIBS/univention/management/console/modules/passwordreset/tokendb.py
    python3-psycopg2=2.* \
    # for $PY_LIBS/univention/management/console/modules/passwordreset/__init__.py
    python3-pylibmc=1.* \
    # for $PY_LIBS/univention/admin/rest/client/__init__.py
    python3-uritemplate=4.1.* \
    # for $PY_LIBS/univention/management/console/oidc.py
    python3-jwt=2.6.* \
    # for the entrypoint.sh script
    wget=1.* \
    # TODO: Remove once sssd dependency is dropped
    sssd=2.8.*



############################################################
# Copy files from first stage

# from univention-management-console-server
COPY --from=build \
  /usr/sbin/univention-management-console-server \
  /usr/sbin/
COPY --from=build \
  /usr/sbin/univention-management-console-module \
  /usr/sbin/

# from python3-univention-heimdal
COPY --from=build \
  ${SRC_PY_LIBS}/heimdal.cpython-311-x86_64-linux-gnu.so \
  ${DST_PY_LIBS}/heimdal.cpython-311-x86_64-linux-gnu.so

# from libunivention-license0
COPY --from=build \
  /usr/lib/x86_64-linux-gnu/libuniventionlicense.so.0.0.1 \
  /usr/lib/x86_64-linux-gnu/libuniventionlicense.so.0

# from libunivention-policy0
COPY --from=build \
  /usr/lib/x86_64-linux-gnu/libuniventionpolicy.so.0.0.1 \
  /usr/lib/x86_64-linux-gnu/libuniventionpolicy.so.0

# from libunivention-config0
COPY --from=build \
  /usr/lib/x86_64-linux-gnu/libuniventionconfig.so.0.0.1 \
  /usr/lib/x86_64-linux-gnu/libuniventionconfig.so.0

# from libunivention-debug1
COPY --from=build \
  /usr/lib/x86_64-linux-gnu/libuniventiondebug.so.1.0.0 \
  /usr/lib/x86_64-linux-gnu/libuniventiondebug.so.1

# from python3-univention-debug
# for ${PY_LIBS}/univention/management/console/log.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/_debug.cpython-311-x86_64-linux-gnu.so \
  ${SRC_PY_LIBS}/univention/debug.py \
  ${SRC_PY_LIBS}/univention/debug2.py \
  ${SRC_PY_LIBS}/univention/logging.py \
  ${DST_PY_LIBS}/univention/

# from python3-notifier (univention package)
# used files: __init__.py dispatch.py log.py nf_generic.py popen.py signals.py
#             threads.py version.py
# unused files: nf_gtk.py nf_qt.py nf_twisted.py
COPY --from=build \
  ${SRC_PY_LIBS}/notifier/*.py \
  ${DST_PY_LIBS}/notifier/
RUN rm ${DST_PY_LIBS}/notifier/{nf_gtk.py,nf_qt.py,nf_twisted.py}

# from python3-pam
COPY --from=build \
  ${SRC_PY_LIBS}/PAM.cpython-311-x86_64-linux-gnu.so \
  ${DST_PY_LIBS}/PAM.cpython-311-x86_64-linux-gnu.so

# from python3-m2crypto
COPY --from=build \
  ${SRC_PY_LIBS}/M2Crypto/ \
  ${DST_PY_LIBS}/M2Crypto/

# from python3-trml2pdf
COPY --from=build \
  ${SRC_PY_LIBS}/trml2pdf/ \
  ${DST_PY_LIBS}/trml2pdf/

# from python3-univention-directory-manager
# used files: __init__.py _ucr.py allocators.py config.py filter.py hook.py
#             layout.py localization.py locking.py mapping.py modules.py
#             nagios.py objects.py syntax.py types.py uexceptions.py uldap.py
#             policy.py cron.py samba.py license_data.py
# unused files: -
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/*.py \
  ${DST_PY_LIBS}/univention/admin/

# from python3-univention-directory-manager-rest-client
# used files: __init__.py
# unused files: __main__.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/rest/client/*.py \
  ${DST_PY_LIBS}/univention/admin/rest/client/
RUN rm ${DST_PY_LIBS}/univention/admin/rest/client/__main__.py

COPY --from=build \
  ${SRC_PY_LIBS}/univention/license.cpython-311-x86_64-linux-gnu.so \
  ${DST_PY_LIBS}/univention/license.cpython-311-x86_64-linux-gnu.so

# from python3-univention-directory-manager
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/handlers/ \
  ${DST_PY_LIBS}/univention/admin/handlers/

# from python3-univention-directory-manager
# used files: __init__.py
# unused files: base.py, binary_props.py, connections.py, encoders.py, exceptions.py, helpers.py, plugins.py, udm.py, utils.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/udm/*.py \
  ${DST_PY_LIBS}/univention/udm/
RUN rm ${DST_PY_LIBS}/univention/udm/{base.py,binary_props.py,connections.py,encoders.py,exceptions.py,helpers.py,plugins.py,udm.py,utils.py}

# from python3-univention-config-registry
COPY --from=build \
  ${SRC_PY_LIBS}/univention/config_registry/ \
  ${DST_PY_LIBS}/univention/config_registry/
COPY --from=build \
  ${SRC_PY_LIBS}/univention/config_registry_info.py \
  ${DST_PY_LIBS}/univention/config_registry_info.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/info_tools.py \
  ${DST_PY_LIBS}/univention/info_tools.py

# from python3-univention-admin-diary and univention-admin-diary-client
# used files: __init__.py client.py events.py
# unused files: -
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admindiary/*.py \
  ${DST_PY_LIBS}/univention/admindiary/

# from python3-univention-lib
# used files: i18n.py ucs.py umc_module.py s4.py misc.py
# unused files: __init__.py account.py admember.py atjobs.py fstab.py
#               ldap_extension.py license_tools.py listenerSharePath.py
#               locking.py package_manager.py password.py
#               ucrLogrotate.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/lib/*.py \
  ${DST_PY_LIBS}/univention/lib/
RUN rm ${DST_PY_LIBS}/univention/lib/{__init__.py,account.py,admember.py,atjobs.py,fstab.py,ldap_extension.py,license_tools.py,listenerSharePath.py,locking.py,package_manager.py,password.py,ucrLogrotate.py}

# from python3-univention-management-console
# used files: acl.py auth.py base.py category.py config.py error.py ldap.py
#             locales.py log.py module.py pam.py resources.py tools.py __init__.py
# unused files: -
COPY --from=build \
  ${SRC_PY_LIBS}/univention/management/console/*.py \
  ${DST_PY_LIBS}/univention/management/console/

# from python3-univention-management-console
# used files: __init__.py decorators.py sanitizers.py mixins.py
# unused files: -
COPY --from=build \
  ${SRC_PY_LIBS}/univention/management/console/modules/*.py \
  ${DST_PY_LIBS}/univention/management/console/modules/

# from python3-univention-management-console
# used files: __init__.py syntax.py tools.py udm_ldap.py
# unused files: -
COPY --from=build \
  ${SRC_PY_LIBS}/univention/management/console/modules/udm/*.py \
  ${DST_PY_LIBS}/univention/management/console/modules/udm/

# from univention-self-service-passwordreset-umc
COPY --from=build \
  ${SRC_PY_LIBS}/univention/management/console/modules/passwordreset/ \
  ${DST_PY_LIBS}/univention/management/console/modules/passwordreset

# from python3-univention-management-console
COPY --from=build \
  ${SRC_PY_LIBS}/univention_management_console-*.egg-info \
  ${DST_PY_LIBS}/univention_management_console-*.egg-info

# from python3-univention
# for $PY_LIBS/univention/admin/uldap.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/password.py \
  ${SRC_PY_LIBS}/univention/uldap.py \
  ${DST_PY_LIBS}/univention/

# from univention-management-console-server
# for $PY_LIBS/univention/management/console/category.py
COPY --from=build \
  /usr/share/univention-management-console/categories/default.xml \
  /usr/share/univention-management-console/categories/default.xml

# from univention-management-console-module-udm
# for $PY_LIBS/univention/management/console/module.py
COPY --from=build \
  /usr/share/univention-management-console/modules/udm.xml \
  /usr/share/univention-management-console/modules/udm.xml

# from univention-self-service-passwordreset-umc
# for $PY_LIBS/univention/management/console/module.py
COPY --from=build \
  /usr/share/univention-management-console/modules/passwordreset.xml \
  /usr/share/univention-management-console/modules/passwordreset.xml

# from univention-management-console-server
# for $PY_LIBS/univention/management/console/server.py
COPY --from=build \
  /usr/share/univention-management-console/oidc/oidc.json \
  /usr/share/univention-management-console/oidc/oidc.json

RUN mkdir /usr/share/doc/univention-management-console-web-server/

# Read by umc-get info
COPY --from=build \
  /usr/share/doc/univention-management-console-server/changelog.gz \
  /usr/share/doc/univention-management-console-server/changelog.gz

COPY --from=build \
  /etc/univention/templates/info/univention-management-console-server.info \
  /etc/univention/templates/info/

COPY --from=build \
  /etc/univention/templates/info/univention-pam.info \
  /etc/univention/templates/info/univention-pam.info

COPY --from=build \
  /etc/univention/templates/files/etc/sssd/sssd.conf \
  /etc/univention/templates/files/etc/sssd/sssd.conf

COPY --from=build \
  /etc/univention/templates/info/univention-management-console-*.info \
  /etc/univention/templates/info/
COPY --from=build \
  /etc/univention/templates/files/etc/pam.d/univention-management-console.d/ \
  /etc/univention/templates/files/etc/pam.d/univention-management-console.d/

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

COPY --from=build \
  /etc/univention/templates/files/var/www/univention/meta.json \
  /etc/univention/templates/files/var/www/univention/meta.json

COPY --from=build \
  /usr/lib/python3/dist-packages/univention/debhelper.py \
  /usr/lib/python3/dist-packages/univention/debhelper.py

COPY --from=build \
  /usr/sbin/univention-config-registry \
  /usr/sbin/univention-config-registry

RUN \
  ln --symbolic --force /usr/sbin/univention-config-registry /usr/sbin/ucr && \
  mkdir --parents /var/cache/univention-config/ && \
  touch /var/cache/univention-config/cache && \
  mkdir /var/log/univention/

# available reports
COPY --from=build \
  ${SRC_PY_LIBS}/univention/directory/ \
  ${DST_PY_LIBS}/univention/directory/
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
RUN mkdir /usr/share/univention-management-console-module-udm/

# email bodies for self-service
COPY --from=build \
  /usr/share/univention-self-service/email_bodies/ \
  /usr/share/univention-self-service/email_bodies

# locales
COPY --from=build \
  /usr/share/locale/de/LC_MESSAGES/univention-*.mo \
  /usr/share/locale/de/LC_MESSAGES/
COPY --from=build \
  /usr/share/univention-management-console/i18n/de/umc-core.mo \
  /usr/share/univention-management-console/i18n/de/udm.mo \
  /usr/share/univention-management-console/i18n/de/passwordreset.mo \
  /usr/share/univention-management-console/i18n/de/

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

RUN mkdir /var/cache/univention-management-console/

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
     # Read by udm_ldap.py UMC module
     mkdir -p /var/lib/univention-appcenter/attributes && \
     echo '{"en_US": {}, "de_DE": {}}' > /var/lib/univention-appcenter/attributes/mapping.json

############################################################
# Set permissions

RUN chown -R 1000:1000 \
    /usr/sbin/univention-management-console-server \
    /usr/sbin/univention-management-console-module \
    /usr/share/univention-management-console \
    /var/cache/univention-management-console \
    /var/log/univention \
    /etc/univention \
    /usr/lib/python3/dist-packages/univention \
    /usr/share/locale/de/LC_MESSAGES \
    /var/lib/univention-appcenter \
    /var/cache/univention-config \
    && chmod -R 755 \
    /entrypoint.d \
    /usr/sbin/univention-management-console-server \
    /usr/sbin/univention-management-console-module \
    /usr/share/univention-management-console \
    /var/cache/univention-management-console \
    /var/log/univention \
    /etc/univention \
    /usr/lib/python3/dist-packages/univention \
    /usr/share/locale/de/LC_MESSAGES \
    /var/lib/univention-appcenter \
    /var/cache/univention-config

############################################################
# Interim code modifications and patches

# Apply patch to support setting individual attributes to read-only in self-service
# hadolint ignore=DL3059
RUN sed --in-place \
--expression="s@'editable': bool(prop.may_change),@'editable': bool(prop.may_change and not ucr.is_true(f'self-service/udm_attributes/{propname}/readonly')),@" \
/usr/lib/python3/dist-packages/univention/management/console/modules/passwordreset/__init__.py

CMD ["/usr/sbin/univention-management-console-server", \
     "--no-daemonize-module-processes", \
     "--log-file", "stdout" \
    ]

# [EOF]
