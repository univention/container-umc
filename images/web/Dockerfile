############################################################
# Global variables

ARG DOCKER_REGISTRY=""

############################################################
# Start first stage

FROM ${DOCKER_REGISTRY}debian:buster-slim AS build

ARG APT_KEY_URL=https://updates.software-univention.de/univention-archive-key-ucs-5x.gpg

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

WORKDIR /


############################################################
# Install Univention APT-Key

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
      ca-certificates=20* \
      curl=7.64.* \
      gpg=2.2.* \
      gpg-agent=2.2.* && \
  curl -fsSL "${APT_KEY_URL}" | apt-key add - && \
  rm -rf /var/lib/apt/lists/*


############################################################
# Install scripts and configs for dpkg

COPY \
  sources.list \
  /etc/apt/sources.list.d/15_ucs-online-version.list


############################################################
# Install univention-management-console-web-server and required dependencies

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
      univention-management-console-web-server=12.0.* \
      python3-univention-debhelper=2.* \
      python3-notifier=0.9.* \
      && \
  rm -rf /var/lib/apt/lists/* && \
  awk \
    '/^Package: univention-management-console-web-server$/{ while(!/^Version: /){getline} print $2 }' \
    /var/lib/dpkg/status > /version

############################################################
# Start second stage

FROM ${DOCKER_REGISTRY}debian:buster-slim AS final

ARG LABEL_CREATED=undefined
ARG LABEL_REVISION=undefined
ARG LABEL_SOURCE=undefined
ARG LABEL_VERSION=undefined
ARG SRC_PY_LIBS="/usr/lib/python3/dist-packages"
ARG DST_PY_LIBS="/usr/lib/python3/dist-packages"

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

WORKDIR /

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
      # for /usr/sbin/univention-management-console-web-server
      python3=3.7.* \
      # for /usr/sbin/univention-management-console-web-server
      python3-cherrypy3=8.9.* \
      # for /usr/sbin/univention-management-console-web-server
      python3-daemon=2.2.* \
      # for /usr/sbin/univention-management-console-web-server
      python3-defusedxml=0.5.* \
      # for $PY_LIBS/univention/admin/syntax.py
      python3-dateutil=2.7.* \
      # for $PY_LIBS/univention/management/console/protocol/session.py
      python3-ldap=3.1.* \
      # for $PY_LIBS/univention/lib/umc_module.py
      python3-magic=2:* \
      # for $PY_LIBS/univention/management/console/protocol/client.py
      python3-openssl=19.* \
      # for $PY_LIBS/univention/admin/syntax.py
      python3-pil=5.4.* \
      # for $PY_LIBS/univention/management/console/locales.py
      python3-polib=1.1.* \
      # for /usr/sbin/univention-management-console-web-server
      python3-pysaml2=4.5.* \
      # for /usr/sbin/univention-management-console-web-server
      python3-six=1.12.* \
      # for $PY_LIBS/univention/admin/__init__.py
      python3-unidecode=1.0.* \
      # for $PY_LIBS/univention/management/console/protocol/server.py
      python3-tornado=5.1.* \
      # for univention-config-registry
      python3-lazy-object-proxy=1.3.* \
      # for the entrypoint.sh script
      wget=1.* \
      && \
  rm -rf /var/lib/apt/lists/*

# for univention-config-registry
COPY --from=build \
  ${SRC_PY_LIBS}/univention/debhelper.py \
  ${DST_PY_LIBS}/univention/debhelper.py

COPY --from=build \
  ${SRC_PY_LIBS}/univention/config_registry/ \
  ${DST_PY_LIBS}/univention/config_registry/

COPY --from=build \
  ${SRC_PY_LIBS}/univention/config_registry_info.py \
  ${DST_PY_LIBS}/univention/config_registry_info.py

COPY --from=build \
  ${SRC_PY_LIBS}/univention/info_tools.py \
  ${DST_PY_LIBS}/univention/info_tools.py

COPY --from=build \
  /usr/sbin/univention-config-registry \
  /usr/sbin/univention-config-registry

RUN \
  ln --symbolic --force /usr/sbin/univention-config-registry /usr/sbin/ucr && \
  mkdir /etc/univention && \
  mkdir --parents /var/cache/univention-config/ && \
  touch /var/cache/univention-config/cache

# from univention-management-console-web-server
COPY --from=build \
  /usr/sbin/univention-management-console-web-server \
  /usr/sbin/univention-management-console-web-server

COPY --from=build \
  /usr/share/univention-management-console/saml/sp.py \
  /usr/share/univention-management-console/saml/sp.py

COPY --from=build \
  /usr/share/univention-management-console-frontend/error.html \
  /usr/share/univention-management-console-frontend/error.html

RUN mkdir /var/cache/univention-management-console/

# from python3-notifier (univention package)
# for /usr/sbin/univention-management-console-web-server
# used files: __init__.py dispatch.py log.py nf_generic.py popen.py signals.py
#             threads.py version.py
# unused files: nf_gtk.py nf_qt.py nf_twisted.py
COPY --from=build \
  ${SRC_PY_LIBS}/notifier/*.py \
  ${DST_PY_LIBS}/notifier/
RUN rm ${DST_PY_LIBS}/notifier/{nf_gtk.py,nf_qt.py,nf_twisted.py}

# from univention-admin-diary-client and python3-univention-admin-diary
# for $PY_LIBS/univention/admin/handlers/__init__.py
# used files: __init__.py client.py events.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admindiary/ \
  ${DST_PY_LIBS}/univention/admindiary/

# from python3-pam
# for $PY_LIBS/univention/management/console/pam.py
COPY --from=build \
  ${SRC_PY_LIBS}/PAM.cpython-37m-x86_64-linux-gnu.so \
  ${DST_PY_LIBS}/PAM.cpython-37m-x86_64-linux-gnu.so

# from python3-univention-management-console
# for /usr/sbin/univention-management-console-web-server
# used files: __init__.py client.py definitions.py message.py modserver.py
#             server.py session.py version.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/management/console/protocol/*.py \
  ${DST_PY_LIBS}/univention/management/console/protocol/

# from python3-univention-management-console
# for $PY_LIBS/univention/management/console/protocol/message.py
# used files: acl.py auth.py base.py category.py config.py error.py ldap.py
#             locales.py log.py module.py pam.py resources.py tools.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/management/console/*.py \
  ${DST_PY_LIBS}/univention/management/console/

# from python3-univention-management-console
# for $PY_LIBS/univention/management/console/protocol/session.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/management/console/modules/decorators.py \
  ${SRC_PY_LIBS}/univention/management/console/modules/sanitizers.py \
  ${DST_PY_LIBS}/univention/management/console/modules/

# from python3-univention-lib
# for $PY_LIBS/univention/management/console/protocol/definitions.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/lib/i18n.py \
  ${SRC_PY_LIBS}/univention/lib/ucs.py \
  ${SRC_PY_LIBS}/univention/lib/umc_module.py \
  ${DST_PY_LIBS}/univention/lib/

# from python3-univention-directory-manager
# for $PY_LIBS/univention/management/console/protocol/session.py
# used files: __init__.py _ucr.py allocators.py config.py filter.py hook.py
#             layout.py localization.py locking.py mapping.py modules.py
#             nagios.py objects.py syntax.py types.py uexceptions.py uldap.py
# unused files: cron.py license_data.py policy.py
# only imported but unused files: samba.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/*.py \
  ${DST_PY_LIBS}/univention/admin/
RUN rm ${DST_PY_LIBS}/univention/admin/{cron.py,license_data.py,policy.py} && \
    echo '' > ${DST_PY_LIBS}/univention/admin/samba.py

# from python3-univention-directory-manager
# for $PY_LIBS/univention/admin/handlers/groups/group.py
# used files: __init__.py
# unused files: -
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/handlers/*.py \
  ${DST_PY_LIBS}/univention/admin/handlers/

# from python3-univention-directory-manager
# for $PY_LIBS/univention/management/console/acl.py
# used files: __base.py domaincontroller_backup.py domaincontroller_master.py
#             domaincontroller_slave.py memberserver.py
# unused files: __init__.py computer.py ipmanagedclient.py linux.py macos.py
#               trustaccount.py ubuntu.py windows.py windows_domaincontroller.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/handlers/computers/*.py \
  ${DST_PY_LIBS}/univention/admin/handlers/computers/
RUN rm ${DST_PY_LIBS}/univention/admin/handlers/computers/{__init__.py,computer.py,ipmanagedclient.py,linux.py,macos.py,trustaccount.py,ubuntu.py,windows.py,windows_domaincontroller.py}

# from python3-univention-directory-manager
# for $PY_LIBS/univention/admin/handlers/computers/__base.py
# used files: __init__.py forward_zone.py reverse_zone.py
# unused files: alias.py dns.py host_record.py ns_record.py ptr_record.py
#               srv_record.py txt_record.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/handlers/dns/*.py \
  ${DST_PY_LIBS}/univention/admin/handlers/dns/
RUN rm ${DST_PY_LIBS}/univention/admin/handlers/dns/{alias.py,dns.py,host_record.py,ns_record.py,ptr_record.py,srv_record.py,txt_record.py}

# from python3-univention-directory-manager
# for $PY_LIBS/univention/admin/handlers/computers/__base.py
# used files: group.py
# unused files: __init__.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/handlers/groups/*.py \
  ${DST_PY_LIBS}/univention/admin/handlers/groups/
RUN rm ${DST_PY_LIBS}/univention/admin/handlers/groups/__init__.py

# from python3-univention-directory-manager
# for $PY_LIBS/univention/admin/handlers/computers/__base.py
# used files: network.py
# unused files: -
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/handlers/networks/*.py \
  ${DST_PY_LIBS}/univention/admin/handlers/networks/

# from python3-univention
# for $PY_LIBS/univention/admin/uldap.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/uldap.py \
  ${DST_PY_LIBS}/univention/uldap.py

COPY --from=build \
  /version \
  /version


############################################################
# Copy Docker-specific files

# from python3-univention-directory-manager
# for $PY_LIBS/univention/admin/uldap.py
COPY \
  libs/admin/license.py \
  libs/admin/password.py \
  ${DST_PY_LIBS}/univention/admin/

# from python3-univention-debug
# for /usr/sbin/univention-management-console-web-server
COPY \
  libs/debug.py \
  ${DST_PY_LIBS}/univention/debug.py

# for Docker ENTRYPOINT
COPY \
  scripts/entrypoint.sh \
  /entrypoint.sh


############################################################
# Define runtime

# Create directory for SAML IDP xml
RUN mkdir -p /usr/share/univention-management-console/saml/idp
ENTRYPOINT ["/entrypoint.sh"]

CMD ["--no-daemon", "--debug=2", "--log-file=/dev/stdout"]

LABEL org.opencontainers.image.created="${LABEL_CREATED}"
LABEL org.opencontainers.image.description="Web service for Univention Management Console"
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later"
LABEL org.opencontainers.image.revision=$LABEL_REVISION
LABEL org.opencontainers.image.source="${LABEL_SOURCE}"
LABEL org.opencontainers.image.title="udm-rest"
LABEL org.opencontainers.image.url="https://docs.software-univention.de/developer-reference-4.4.html#chap:umc"
LABEL org.opencontainers.image.vendor="Univention GmbH"
LABEL org.opencontainers.image.version="${LABEL_VERSION}"

# [EOF]
