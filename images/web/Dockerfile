############################################################
# Global variables

ARG DOCKER_REGISTRY=""

############################################################
# Set Docker environment

FROM ${DOCKER_REGISTRY}debian:buster-slim AS build

ARG APT_KEY_URL=https://updates.software-univention.de/univention-archive-key-ucs-5x.gpg

# Ignore questions from debconf
ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

WORKDIR /


############################################################
# Install Univention APT-Key

RUN \
  apt-get update && \
  apt-get --assume-yes --verbose-versions --no-install-recommends install \
    ca-certificates=20200601~deb10u2 \
    curl=7.64.0-4+deb10u1 \
    gpg=2.2.12-1+deb10u1 \
    gpg-agent=2.2.12-1+deb10u1 && \
  curl -fsSL "${APT_KEY_URL}" | apt-key add - && \
  rm -rf /var/lib/apt/lists/*


############################################################
# Install scripts and configs for dpkg

COPY \
  sources.list \
  /etc/apt/sources.list.d/15_ucs-online-version.list


############################################################
# Install univention-management-console-web-server and required dependencies

# TODO: remove nameserver after public release
RUN \
  echo 'nameserver 192.168.0.97' > /etc/resolv.conf && \
  apt-get update && \
  apt-get --assume-yes --no-install-recommends install \
    univention-management-console-web-server && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update

RUN \
  apt-get --assume-yes --no-install-recommends install \
    python3-notifier

############################################################
# Second stage

FROM ${DOCKER_REGISTRY}debian:buster-slim AS final

ARG SRC_PY_LIBS="/usr/lib/python3/dist-packages"
ARG DST_PY_LIBS="/usr/lib/python3/dist-packages"

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

WORKDIR /

RUN \
  apt-get update && \
  apt-get --assume-yes --no-install-recommends install \
    # for /usr/sbin/univention-management-console-web-server
    python3 \
    # for /usr/sbin/univention-management-console-web-server
    python3-cherrypy3 \
    # for /usr/sbin/univention-management-console-web-server
    python3-daemon \
    # for /usr/sbin/univention-management-console-web-server
    python3-defusedxml \
    # for $PY_LIBS/univention/admin/syntax.py
    python3-dateutil \
    # for /usr/lib/python3/dist-packages/univention/management/console/protocol/session.py
    python3-ldap \
    # for $PY_LIBS/univention/lib/umc_module.py
    python3-magic \
    # for $PY_LIBS/univention/management/console/protocol/client.py
    python3-openssl \
    # for $PY_LIBS/univention/admin/syntax.py
    python3-pil \
    # for $PY_LIBS/univention/management/console/locales.py
    python3-polib \
    # for /usr/sbin/univention-management-console-web-server
    python3-pysaml2 \
    # for /usr/sbin/univention-management-console-web-server
    python3-six \
    # for $PY_LIBS/univention/management/console/protocol/server.py
    python3-tornado && \
  rm -rf /var/lib/apt/lists/*

# from univention-management-console-web-server
COPY --from=build \
  /usr/sbin/univention-management-console-web-server \
  /usr/sbin/univention-management-console-web-server

# from univention-admin-diary-client and python3-univention-admin-diary
# for /usr/lib/python3/dist-packages/univention/admin/handlers/__init__.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admindiary/__init__.py \
  ${SRC_PY_LIBS}/univention/admindiary/client.py \
  ${SRC_PY_LIBS}/univention/admindiary/events.py \
  ${DST_PY_LIBS}/univention/admindiary/

# from python3-notifier (univention package)
# for /usr/sbin/univention-management-console-web-server
COPY --from=build \
  ${SRC_PY_LIBS}/notifier/__init__.py \
  ${SRC_PY_LIBS}/notifier/dispatch.py \
  ${SRC_PY_LIBS}/notifier/log.py \
  ${SRC_PY_LIBS}/notifier/nf_generic.py \
  ${SRC_PY_LIBS}/notifier/popen.py \
  ${SRC_PY_LIBS}/notifier/signals.py \
  ${SRC_PY_LIBS}/notifier/threads.py \
  ${SRC_PY_LIBS}/notifier/version.py \
  ${DST_PY_LIBS}/notifier/

# from python3-pam
# for /usr/lib/python3/dist-packages/univention/management/console/pam.py
COPY --from=build \
  ${SRC_PY_LIBS}/PAM.cpython-37m-x86_64-linux-gnu.so \
  ${DST_PY_LIBS}/PAM.cpython-37m-x86_64-linux-gnu.so

# from python3-univention-management-console
# for /usr/sbin/univention-management-console-web-server
COPY --from=build \
  ${SRC_PY_LIBS}/univention/management/console/protocol/__init__.py \
  ${SRC_PY_LIBS}/univention/management/console/protocol/client.py \
  ${SRC_PY_LIBS}/univention/management/console/protocol/definitions.py \
  ${SRC_PY_LIBS}/univention/management/console/protocol/message.py \
  ${SRC_PY_LIBS}/univention/management/console/protocol/modserver.py \
  ${SRC_PY_LIBS}/univention/management/console/protocol/server.py \
  ${SRC_PY_LIBS}/univention/management/console/protocol/session.py \
  ${SRC_PY_LIBS}/univention/management/console/protocol/version.py \
  ${DST_PY_LIBS}/univention/management/console/protocol/

# from python3-univention-management-console
# for /usr/lib/python3/dist-packages/univention/management/console/protocol/message.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/management/console/acl.py \
  ${SRC_PY_LIBS}/univention/management/console/auth.py \
  ${SRC_PY_LIBS}/univention/management/console/base.py \
  ${SRC_PY_LIBS}/univention/management/console/category.py \
  ${SRC_PY_LIBS}/univention/management/console/config.py \
  ${SRC_PY_LIBS}/univention/management/console/error.py \
  ${SRC_PY_LIBS}/univention/management/console/ldap.py \
  ${SRC_PY_LIBS}/univention/management/console/locales.py \
  ${SRC_PY_LIBS}/univention/management/console/log.py \
  ${SRC_PY_LIBS}/univention/management/console/module.py \
  ${SRC_PY_LIBS}/univention/management/console/pam.py \
  ${SRC_PY_LIBS}/univention/management/console/resources.py \
  ${SRC_PY_LIBS}/univention/management/console/tools.py \
  ${DST_PY_LIBS}/univention/management/console/

# from python3-univention-management-console
# for /usr/lib/python3/dist-packages/univention/management/console/protocol/session.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/management/console/modules/decorators.py \
  ${SRC_PY_LIBS}/univention/management/console/modules/sanitizers.py \
  ${DST_PY_LIBS}/univention/management/console/modules/

# from python3-univention-lib
# for /usr/lib/python3/dist-packages/univention/management/console/protocol/definitions.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/lib/i18n.py \
  ${SRC_PY_LIBS}/univention/lib/ucs.py \
  ${SRC_PY_LIBS}/univention/lib/umc_module.py \
  ${DST_PY_LIBS}/univention/lib/

# from python3-univention-directory-manager
# for /usr/lib/python3/dist-packages/univention/management/console/protocol/session.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/__init__.py \
  ${SRC_PY_LIBS}/univention/admin/_ucr.py \
  ${SRC_PY_LIBS}/univention/admin/allocators.py \
  ${SRC_PY_LIBS}/univention/admin/config.py \
  ${SRC_PY_LIBS}/univention/admin/filter.py \
  ${SRC_PY_LIBS}/univention/admin/hook.py \
  ${SRC_PY_LIBS}/univention/admin/layout.py \
  ${SRC_PY_LIBS}/univention/admin/localization.py \
  ${SRC_PY_LIBS}/univention/admin/locking.py \
  ${SRC_PY_LIBS}/univention/admin/mapping.py \
  ${SRC_PY_LIBS}/univention/admin/modules.py \
  ${SRC_PY_LIBS}/univention/admin/nagios.py \
  ${SRC_PY_LIBS}/univention/admin/objects.py \
  ${SRC_PY_LIBS}/univention/admin/uexceptions.py \
  ${SRC_PY_LIBS}/univention/admin/uldap.py \
  ${SRC_PY_LIBS}/univention/admin/syntax.py \
  ${SRC_PY_LIBS}/univention/admin/types.py \
  ${DST_PY_LIBS}/univention/admin/

# from python3-univention-directory-manager
# for /usr/lib/python3/dist-packages/univention/admin/handlers/groups/group.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/handlers/__init__.py \
  ${DST_PY_LIBS}/univention/admin/handlers/

# from python3-univention-directory-manager
# for /usr/lib/python3/dist-packages/univention/management/console/acl.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/handlers/computers/__base.py \
  ${SRC_PY_LIBS}/univention/admin/handlers/computers/domaincontroller_backup.py \
  ${SRC_PY_LIBS}/univention/admin/handlers/computers/domaincontroller_master.py \
  ${SRC_PY_LIBS}/univention/admin/handlers/computers/domaincontroller_slave.py \
  ${SRC_PY_LIBS}/univention/admin/handlers/computers/memberserver.py \
  ${DST_PY_LIBS}/univention/admin/handlers/computers/

# from python3-univention-directory-manager
# for /usr/lib/python3/dist-packages/univention/admin/handlers/computers/__base.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/handlers/dns/__init__.py \
  ${SRC_PY_LIBS}/univention/admin/handlers/dns/forward_zone.py \
  ${SRC_PY_LIBS}/univention/admin/handlers/dns/reverse_zone.py \
  ${DST_PY_LIBS}/univention/admin/handlers/dns/

# from python3-univention-directory-manager
# for /usr/lib/python3/dist-packages/univention/admin/handlers/computers/__base.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/handlers/networks/network.py \
  ${DST_PY_LIBS}/univention/admin/handlers/networks/

# from python3-univention-directory-manager
# for /usr/lib/python3/dist-packages/univention/admin/handlers/computers/__base.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/handlers/groups/group.py \
  ${DST_PY_LIBS}/univention/admin/handlers/groups/

# from python3-univention
# for /usr/lib/python3/dist-packages/univention/admin/uldap.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/uldap.py \
  ${DST_PY_LIBS}/univention/uldap.py


############################################################
# Copy Docker-specific files

# from python3-univention-directory-manager
# for /usr/lib/python3/dist-packages/univention/admin/uldap.py
COPY \
  libs/admin/license.py \
  libs/admin/password.py \
  ${DST_PY_LIBS}/univention/admin/

# from python3-univention-config-registry
# for /usr/lib/python3/dist-packages/univention/management/console/log.py
COPY \
  libs/config_registry.py \
  ${DST_PY_LIBS}/univention/config_registry.py

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

ENTRYPOINT ["/entrypoint.sh"]

CMD ["--no-daemon", "--debug=2", "--log-file=/dev/stdout"]

# [EOF]
