############################################################
# Global variables

ARG UCS_BASE_IMAGE_TAG=v0.7.2
ARG UCS_BASE_IMAGE=gitregistry.knut.univention.de/univention/components/ucs-base-image/ucs-base-505

ARG PORTAL_UDM_EXTENSIONS_IMAGE=gitregistry.knut.univention.de/univention/components/univention-portal/portal-udm-extensions
ARG PORTAL_UDM_EXTENSIONS_TAG=0.4.3

ARG OX_CONNECTOR_EXTENSIONS_IMAGE=gitregistry.knut.univention.de/univention/open-xchange/provisioning/ox-connector-dependencies
ARG OX_CONNECTOR_EXTENSIONS_TAG=0.3.4

FROM ${PORTAL_UDM_EXTENSIONS_IMAGE}:${PORTAL_UDM_EXTENSIONS_TAG} AS portal-udm-extensions
FROM ${OX_CONNECTOR_EXTENSIONS_IMAGE}:${OX_CONNECTOR_EXTENSIONS_TAG} AS ox-connector-extensions

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
  apt-get --quiet update && \
  # install Univention bash helper functions dependency
  DEBIAN_FRONTEND=noninteractive \
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
      shell-univention-lib=9.* \
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
      python3=3.7.* \
      python3-distutils=3.7.* \
      patch=2.* \
      # for /usr/sbin/univention-config-registry
      python3-lazy-object-proxy=1.3.* \
      # the python3-univention-debug postinst uses py3compile
      python3-minimal=3.7.* \
      # for /usr/sbin/univention-config-registry
      python3-six=1.12.* \
      && \
  apt-get download \
    # UV package
    libunivention-config0=15.* \
    libunivention-debug1=12.* \
    libunivention-license0=11.* \
    libunivention-policy0=11.* \
    # for /usr/share/locale/de/LC_MESSAGES/univention-admin*.mo
    python-univention-directory-manager=15.* \
    python3-notifier=0.9.* \
    # use UCS-repo because it is not yet in Debian/stable (just bullseye)
    python3-m2crypto=0.31.* \
    python3-pam=0.4.2-* \
    python3-trml2pdf=1.2-* \
    python3-univention=13.* \
    # for $PY_LIBS/univention/admindiary/__init__.py
    python3-univention-admin-diary=2.* \
    python3-univention-config-registry=15.* \
    python3-univention-directory-manager=15.* \
    python3-univention-directory-manager-rest-client=10.* \
    python3-univention-directory-reports=12.* \
    python3-univention-heimdal=10.* \
    python3-univention-lib=9.* \
    python3-univention-license=11.* \
    python3-univention-management-console=12.* \
    python3-univention-debhelper=2.* \
    # for $PY_LIBS/univention/admindiary/client.py and
    # $PY_LIBS/univention/admindiary/events.py
    univention-admin-diary-client=2.* \
    # for /usr/sbin/univention-config-registry
    univention-config=15.* \
    univention-directory-reports=12.* \
    univention-management-console-module-udm=10.* \
    univention-management-console-server=12.* \
    univention-pam=13.* \
    # for the self-service
    univention-self-service-passwordreset-umc=5.* \
    && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
  echo 'path-exclude /usr/sbin/univention-management-console-acls' >> /etc/dpkg/dpkg.cfg.d/univention && \
  echo 'path-include /usr/share/doc/univention-management-console-server/changelog.Debian.gz' >> /etc/dpkg/dpkg.cfg.d/univention && \
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
  apt-get --quiet update && \
  apt-get download \
    univention-management-console-web-server=12.* \
    univention-management-console-frontend=12.* \
    && \
  for i in /apt/*.deb; do dpkg --extract "$i" /; done && \
  rm -rf /apt/

COPY disable_license_check.patch \
     disable_suffixed_cookies.patch \
     make_uldap_start-tls_configurable.patch \
     self_service_credentials.patch \
     set_password_without_kerberos.patch \
     use_try_first.patch \
     unsafe_saml_for_debug.patch \
     /

RUN  \
  patch -p 0 -d / -i /disable_license_check.patch && \
    rm /disable_license_check.patch && \
  patch -p 0 -d / -i /disable_suffixed_cookies.patch && \
    rm /disable_suffixed_cookies.patch && \
  patch -p 0 -d / -i /make_uldap_start-tls_configurable.patch && \
    rm /make_uldap_start-tls_configurable.patch && \
  patch -p 0 -d / -i /self_service_credentials.patch && \
    rm /self_service_credentials.patch && \
  patch -p 0 -d / -i /set_password_without_kerberos.patch && \
    rm /set_password_without_kerberos.patch && \
  patch -p 0 -d / -i /use_try_first.patch && \
    rm /use_try_first.patch && \
  patch -p 0 -d / -i /unsafe_saml_for_debug.patch && \
    rm /unsafe_saml_for_debug.patch

############################################################
# Start second stage

FROM ${UCS_BASE_IMAGE}:${UCS_BASE_IMAGE_TAG} AS final

ARG SRC_PY_LIBS="/usr/lib/python3/dist-packages"
ARG DST_PY_LIBS="/usr/lib/python3/dist-packages"

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

WORKDIR /

############################################################
# Install patched packages from UCS repository

RUN \
  apt-get --quiet update && \
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
      ca-certificates=20* \
      curl=7.64.* \
      gpg=2.2.* \
      gpg-agent=2.2.* \
      && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN \
  apt-get --quiet update && \
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
      libc-bin=2.28-* \
      locales=2.28-* \
      # for $PY_LIBS/univention/admin/password.py
      libhdb9-heimdal=7.5.* \
      # for $PY_LIBS/univention/admin/password.py
      libkrb5-26-heimdal=7.5.* \
      libpam0g=1.3.* \
      libpam-ldap=186-* \
      pam-saml=1.9.* \
      # for $PY_LIBS/univention/management/console/pam.py
      libpam-cracklib=1.3.* \
      # for $PY_LIBS/univention/management/console/protocol/session.py
      # the debian-buster version would cause a segfault.
      python3-ldap=3.1.* \
      # for $PY_LIBS/univention/management/console/message.py
      # calling $PY_LIBS/univention/uldap.py
      cy2-saml=1.9.* \
      # for pylibmc (SASL authentication with memcached)
      libsasl2-modules=2.1.*\
    && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

############################################################
# Install Python and entrypoint.sh requirements

RUN \
  apt-get --quiet update && \
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
      # for $PY_LIBS/univention/admin/password.py
      python3-bcrypt=3.1.* \
      # for /usr/sbin/univention-management-console-server
      python3-daemon=2.2.* \
      # for $PY_LIBS/univention/admin/syntax.py
      python3-dateutil=2.7.* \
      # for /usr/sbin/univention-management-console-web-server
      python3-defusedxml=0.5.* \
      # for $PY_LIBS/univention/lib/umc_module.py
      python3-magic=2:* \
      # for $PY_LIBS/univention/management/console/protocol/server.py
      python3-openssl=19.* \
      # for $PY_LIBS/univention/admin/syntax.py
      python3-pil=5.4.* \
      # for $PY_LIBS/univention/management/console/locales.py
      python3-polib=1.1.* \
      # for $PY_LIBS/univention/management/console/protocol/server.py
      python3-tornado=5.1.* \
      # for $PY_LIBS/univention/config_registry/
      python3-lazy-object-proxy=1.3.* \
      python3-six=1.12.* \
      # for $PY_LIBS/univention/password.py
      python3-cracklib=2.* \
      # for ...
      python3-cryptography=2.* \
      # for $PY_LIBS/univention/admin/handlers/settings/
      python3-apt=1.8.* \
      # for python3-trml2pdf
      python3-reportlab=3.5.* \
      # for $PY_LIBS/univention/admin/password.py
      python3-passlib=1.7.* \
      # for ...
      python3-pycurl=7.* \
      # for /usr/sbin/univention-management-console-web-server
      python3-cherrypy3=8.* \
      python3-pysaml2=4.5.* \
      # for $PY_LIBS/univention/management/console/server.py
      python3-sdnotify=0.* \
      # for ...
      python3-setproctitle=1.* \
      # for ...
      python3-tornado=5.* \
      # for $PY_LIBS/univention/management/console/protocol/modserver.py
      python3-tzlocal=1.* \
      # for $PY_LIBS/univention/admin/__init__.py
      python3-unidecode=1.0.* \
      # for $PY_LIBS/univention/management/console/modules/passwordreset/tokendb.py
      python3-psycopg2=2.* \
      # for $PY_LIBS/univention/management/console/modules/passwordreset/__init__.py
      python3-pylibmc=1.* \
      # for $PY_LIBS/univention/admin/rest/client/__init__.py
      python3-uritemplate=0.6-* \
      # for the entrypoint.sh script
      wget=1.* \
      && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*


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
  ${SRC_PY_LIBS}/heimdal.cpython-37m-x86_64-linux-gnu.so \
  ${DST_PY_LIBS}/heimdal.cpython-37m-x86_64-linux-gnu.so

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
  ${SRC_PY_LIBS}/univention/_debug.cpython-37m-x86_64-linux-gnu.so \
  ${SRC_PY_LIBS}/univention/debug.py \
  ${SRC_PY_LIBS}/univention/debug2.py \
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
  ${SRC_PY_LIBS}/PAM.cpython-37m-x86_64-linux-gnu.so \
  ${DST_PY_LIBS}/PAM.cpython-37m-x86_64-linux-gnu.so

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
  ${SRC_PY_LIBS}/univention/license.cpython-37m-x86_64-linux-gnu.so \
  ${DST_PY_LIBS}/univention/license.cpython-37m-x86_64-linux-gnu.so

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

# Extension: Portal extensions
COPY --from=portal-udm-extensions /udm/api/ \
    /usr/lib/python3/dist-packages/univention/udm/modules/

COPY --from=portal-udm-extensions /udm/syntax/ \
    /usr/lib/python3/dist-packages/univention/admin/syntax.d/

COPY --from=portal-udm-extensions /udm/handlers \
    /usr/lib/python3/dist-packages/univention/admin/handlers/portals

COPY --from=portal-udm-extensions /udm/univention-portal.xml \
    /usr/share/univention-management-console/modules/univention-portal.xml

# Extension: OX Connector
COPY --from=ox-connector-extensions /dependencies/handlers/ \
   ${DST_PY_LIBS}/univention/admin/handlers/

COPY --from=ox-connector-extensions /dependencies/syntax.d/ \
   ${DST_PY_LIBS}/univention/admin/syntax.d/

COPY --from=ox-connector-extensions /dependencies/hooks.d/ \
   ${DST_PY_LIBS}/univention/admin/hooks.d/

COPY --from=ox-connector-extensions /dependencies/ox-common.xml \
   /usr/share/univention-management-console/modules/udm-oxresources-oxresources.xml

# from python3-univention-condig-registry
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
# for /usr/sbin/univention-management-console-server
# used files: client.py definitions.py message.py server.py session.py
#             version.py modserver.py __init__.py
# unused files: -
COPY --from=build \
  ${SRC_PY_LIBS}/univention/management/console/protocol/*.py \
  ${DST_PY_LIBS}/univention/management/console/protocol/

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

RUN mkdir /usr/share/doc/univention-management-console-web-server/

# Read by umc-get info
COPY --from=build \
  /usr/share/doc/univention-management-console-server/changelog.Debian.gz \
  /usr/share/doc/univention-management-console-server/changelog.Debian.gz

COPY --from=build \
  /etc/univention/templates/info/univention-management-console-server.info \
  /etc/univention/templates/info/

COPY --from=build \
  /etc/univention/templates/info/univention-pam.info \
  /etc/univention/templates/info/univention-pam.info
COPY --from=build \
  /etc/univention/templates/files/etc/pam_ldap.conf \
  /etc/univention/templates/files/etc/pam_ldap.conf

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

############################################################
# Copy Docker-specific files

RUN mkdir /var/cache/univention-management-console/

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
    mkdir -p /usr/share/univention-management-console/saml/idp

CMD ["/usr/sbin/univention-management-console-server", \
     "--no-daemonize-module-processes", \
     "--log-file", "stdout" \
    ]

# [EOF]
