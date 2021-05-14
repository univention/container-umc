############################################################
# Global variables

ARG DOCKER_REGISTRY=""

############################################################
# Start first stage

FROM ${DOCKER_REGISTRY}debian:buster-slim AS build

ARG APT_KEY_URL=https://updates.software-univention.de/univention-archive-key-ucs-5x.gpg

ARG PY_LIBS="/usr/lib/python3/dist-packages"

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

WORKDIR /apt


############################################################
# Install Univention APT-Key

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
      ca-certificates=20* \
      curl=7.64.* \
      gpg=2.2.* \
      gpg-agent=2.2.* \
      && \
  curl -fsSL "${APT_KEY_URL}" | apt-key add - && \
  rm -rf /var/lib/apt/lists/*


############################################################
# Install scripts and configs for dpkg

COPY \
  sources.list \
  /etc/apt/sources.list.d/15_ucs-online-version.list

# Sourced by univention-management-console-server.postinst
COPY \
  scripts/umc.sh \
  /usr/share/univention-lib/umc.sh

# Sourced by univention-management-console-server.postinst
COPY \
  scripts/all.sh \
  /usr/share/univention-lib/all.sh

# Sourced by univention-management-console-module-udm.postinst
COPY \
  scripts/join.sh \
  /usr/share/univention-lib/join.sh

COPY \
  scripts/fake-bin.sh \
  /usr/local/bin/ucr
COPY \
  scripts/fake-bin.sh \
  /usr/local/bin/create_logfile
COPY \
  scripts/fake-bin.sh \
  /usr/local/bin/systemctl
COPY \
  scripts/fake-bin.sh \
  /usr/local/bin/a2dissite
COPY \
  scripts/fake-bin.sh \
  /usr/sbin/univention-management-console-acls
COPY \
  scripts/fake-bin.sh \
  /usr/local/bin/call_joinscript


############################################################
# Install univention-management-console-server and required dependencies

RUN \
  # For apt-get download sandbox
  chown _apt /apt && \
  mkdir /var/log/univention/ && \
  mkdir -p /usr/share/locale/de/LC_MESSAGES/ && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get --assume-yes --no-install-recommends install \
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
    && \
  rm -rf /var/lib/apt/lists/* && \
  echo 'path-exclude /usr/sbin/univention-management-console-acls' >> /etc/dpkg/dpkg.cfg.d/univention && \
  echo 'path-include /usr/share/doc/univention-management-console-server/changelog.Debian.gz' >> /etc/dpkg/dpkg.cfg.d/univention && \
  echo 'path-include /usr/share/locale/de/LC_MESSAGES/univention-directory-reports.mo' >> /etc/dpkg/dpkg.cfg.d/univention && \
  dpkg --install --force-depends /apt/* && \
  rm -rf /apt/

############################################################
# Start second stage

FROM ${DOCKER_REGISTRY}debian:buster-slim AS final

ARG APT_KEY_URL=https://updates.software-univention.de/univention-archive-key-ucs-5x.gpg

ARG SRC_PY_LIBS="/usr/lib/python3/dist-packages"
ARG DST_PY_LIBS="/usr/lib/python3/dist-packages"

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

WORKDIR /


############################################################
# Install patched packages from UCS repository

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
      ca-certificates=20* \
      curl=7.64.* \
      gpg=2.2.* \
      gpg-agent=2.2.* \
      && \
  curl -fsSL "${APT_KEY_URL}" | apt-key add - && \
  rm -rf /var/lib/apt/lists/*
COPY \
  sources.list \
  /etc/apt/sources.list.d/15_ucs-online-version.list
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get --assume-yes --no-install-recommends install \
      libc-bin=2.28-* \
      locales=2.28-* \
      # for $PY_LIBS/univention/admin/password.py
      libhdb9-heimdal=7.5.* \
      # for $PY_LIBS/univention/admin/password.py
      libkrb5-26-heimdal=7.5.* \
      libpam0g=1.3.* \
      libpam-ldap=186-* \
      pam-saml=1.9.* \
    && \
  rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/15_ucs-online-version.list

############################################################
# Install Python requirements

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get --assume-yes --no-install-recommends install \
      # for $PY_LIBS/univention/admin/password.py
      python3-bcrypt=3.1.* \
      # for /usr/sbin/univention-management-console-server
      python3-daemon=2.2.* \
      # for $PY_LIBS/univention/admin/syntax.py
      python3-dateutil=2.7.* \
      # for $PY_LIBS/univention/management/console/protocol/session.py
      python3-ldap=3.1.* \
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
      # for $PY_LIBS/univention/admin/handlers/settings/
      python3-apt=1.8.* \
      # for python3-trml2pdf
      python3-reportlab=3.5.* \
      # for $PY_LIBS/univention/admin/password.py
      python3-passlib=1.7.* \
      # for $PY_LIBS/univention/admin/__init__.py
      python3-unidecode=1.0.* \
      && \
  rm -rf /var/lib/apt/lists/*


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

COPY --from=build \
  ${SRC_PY_LIBS}/univention/license.cpython-37m-x86_64-linux-gnu.so \
  ${DST_PY_LIBS}/univention/license.cpython-37m-x86_64-linux-gnu.so

# from python3-univention-directory-manager
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/handlers/ \
  ${DST_PY_LIBS}/univention/admin/handlers/

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
#               ucrLogrotate.py umc.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/lib/*.py \
  ${DST_PY_LIBS}/univention/lib/
RUN rm ${DST_PY_LIBS}/univention/lib/{__init__.py,account.py,admember.py,atjobs.py,fstab.py,ldap_extension.py,license_tools.py,listenerSharePath.py,locking.py,package_manager.py,password.py,ucrLogrotate.py,umc.py}

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

# from python3-univention-management-console
# for /usr/sbin/univention-management-console-server
# used files: client.py definitions.py message.py server.py session.py
#             version.py modserver.py __init__.py
# unused files: -
COPY --from=build \
  ${SRC_PY_LIBS}/univention/management/console/protocol/*.py \
  ${DST_PY_LIBS}/univention/management/console/protocol/

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

RUN mkdir /usr/share/doc/univention-management-console-server/

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
  /etc/univention/templates/files/etc/pam.d/univention-management-console.d/ \
  /etc/univention/templates/files/etc/pam.d/univention-management-console.d/

COPY --from=build \
  /usr/lib/python3/dist-packages/univention/debhelper.py \
  /usr/lib/python3/dist-packages/univention/debhelper.py

COPY --from=build \
  /usr/sbin/univention-config-registry \
  /usr/sbin/univention-config-registry
RUN mkdir --parents /var/cache/univention-config/ && \
  touch /var/cache/univention-config/cache

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
  /usr/share/locale/de/LC_MESSAGES/univention-directory-reports.mo \
  /usr/share/locale/de/LC_MESSAGES/univention-directory-reports.mo

############################################################
# Copy Docker-specific files

# from python3-univention-debug, univention package
COPY \
  libs/debug.py \
  ${DST_PY_LIBS}/univention/debug.py

# from python3-univention-management-console, univention package
COPY \
  libs/management/console/log.py \
  ${DST_PY_LIBS}/univention/management/console/log.py

COPY scripts/entrypoint.sh /entrypoint.sh

############################################################
# Define runtime

# build all locales
RUN echo -en 'en_US.UTF-8 UTF-8\nde_DE.UTF-8 UTF-8\n' >> /etc/locale.gen && \
	localedef -i de_DE -c -f UTF-8 -A /usr/share/locale/locale.alias de_DE.UTF-8 && \
	localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENTRYPOINT ["/entrypoint.sh"]

CMD ["--no-daemon", "--debug=2", "--log-file=/dev/stdout"]

# [EOF]
