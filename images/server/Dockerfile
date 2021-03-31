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
      gpg-agent=2.2.* && \
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
  /usr/local/bin/univention-config-registry
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


############################################################
# Install univention-management-console-server and required dependencies

RUN \
  # For apt-get download sandbox
  chown _apt /apt && \
  mkdir /var/log/univention/ && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get --assume-yes --no-install-recommends install \
      # the python3-univention-debug postinst uses py3compile
      python3-minimal=3.7.* && \
  apt-get download \
    # UV package
    python3-notifier \
    # use UCS-repo because it is not yet in Debian/stable (just bullseye)
    python3-pam \
    python3-univention \
    python3-univention-directory-manager \
    python3-univention-heimdal \
    python3-univention-lib \
    python3-univention-management-console \
    # for $PY_LIBS/univention/admindiary/__init__.py
    python3-univention-admin-diary \
    # for $PY_LIBS/univention/admindiary/client.py and
    # $PY_LIBS/univention/admindiary/events.py
    univention-admin-diary-client \
    univention-management-console-server \
    univention-management-console-module-udm && \
  rm -rf /var/lib/apt/lists/* && \
  dpkg --install --force-depends /apt/* && \
  rm ${PY_LIBS}/univention/admin/license.py && \
  rm ${PY_LIBS}/univention/admin/password.py && \
  rm -rf /apt/


############################################################
# Start second stage

FROM ${DOCKER_REGISTRY}debian:buster-slim AS final

ARG SRC_PY_LIBS="/usr/lib/python3/dist-packages"
ARG DST_PY_LIBS="/usr/lib/python3/dist-packages"

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

WORKDIR /


############################################################
# Install Python requirements

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get --assume-yes --no-install-recommends install \
      # for $PY_LIBS/univention/admin/password.py
      libhdb9-heimdal=7.5.* \
      # for $PY_LIBS/univention/admin/password.py
      libkrb5-26-heimdal=7.5.* \
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
      #python3-six \
      # for $PY_LIBS/univention/management/console/protocol/server.py
      python3-tornado=5.1.* && \
  rm -rf /var/lib/apt/lists/*


############################################################
# Copy files from first stage

# from univention-management-console-server
COPY --from=build \
  /usr/sbin/univention-management-console-server \
  /usr/sbin/

# from python3-univention-heimdal
COPY --from=build \
  ${SRC_PY_LIBS}/heimdal.cpython-37m-x86_64-linux-gnu.so \
  ${DST_PY_LIBS}/heimdal.cpython-37m-x86_64-linux-gnu.so

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

# from python3-univention-directory-manager
# used files: __init__.py _ucr.py allocators.py config.py filter.py hook.py
#             layout.py localization.py locking.py mapping.py modules.py
#             nagios.py objects.py syntax.py types.py uexceptions.py uldap.py
# unused fies: cron.py license_data.py policy.py samba.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/*.py \
  ${DST_PY_LIBS}/univention/admin/
RUN rm ${DST_PY_LIBS}/univention/admin/{cron.py,license_data.py,policy.py,samba.py}

# from python3-univention-directory-manager
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admin/handlers/ \
  ${DST_PY_LIBS}/univention/admin/handlers/

# from python3-univention-admin-diary and univention-admin-diary-client
# used files: __init__.py client.py events.py
# unused files: -
COPY --from=build \
  ${SRC_PY_LIBS}/univention/admindiary/*.py \
  ${DST_PY_LIBS}/univention/admindiary/

# from python3-univention-lib
# used files: i18n.py ucs.py umc_module.py
# unused files: __init__.py account.py admember.py atjobs.py fstab.py
#               ldap_extension.py license_tools.py listenerSharePath.py
#               locking.py misc.py package_manager.py password.py s4.py
#               ucrLogrotate.py umc.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/lib/*.py \
  ${DST_PY_LIBS}/univention/lib/
RUN rm ${DST_PY_LIBS}/univention/lib/{__init__.py,account.py,admember.py,atjobs.py,fstab.py,ldap_extension.py,license_tools.py,listenerSharePath.py,locking.py,misc.py,package_manager.py,password.py,s4.py,ucrLogrotate.py,umc.py}

# from python3-univention-management-console
# used files: acl.py auth.py base.py category.py config.py error.py ldap.py
#             locales.py log.py module.py pam.py resources.py tools.py
# unused files: __init__.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/management/console/*.py \
  ${DST_PY_LIBS}/univention/management/console/
RUN rm ${DST_PY_LIBS}/univention/management/console/__init__.py

# from python3-univention-management-console
# used files: __init__.py decorators.py sanitizers.py
# unused files: mixins.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/management/console/modules/*.py \
  ${DST_PY_LIBS}/univention/management/console/modules/
RUN rm ${DST_PY_LIBS}/univention/management/console/modules/mixins.py

# from python3-univention-management-console
# used files: __init__.py syntax.py tools.py udm_ldap.py
# unused files: -
COPY --from=build \
  ${SRC_PY_LIBS}/univention/management/console/modules/udm/*.py \
  ${DST_PY_LIBS}/univention/management/console/modules/udm/

# from python3-univention-management-console
# for /usr/sbin/univention-management-console-server
# used files: client.py definitions.py message.py server.py session.py
#             version.py
# unused files: __init__.py modserver.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/management/console/protocol/*.py \
  ${DST_PY_LIBS}/univention/management/console/protocol/
RUN rm ${DST_PY_LIBS}/univention/management/console/protocol/{__init__.py,modserver.py}

# from python3-univention
# for $PY_LIBS/univention/admin/uldap.py
COPY --from=build \
  ${SRC_PY_LIBS}/univention/uldap.py \
  ${DST_PY_LIBS}/univention/uldap.py

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


############################################################
# Copy Docker-specific files

# from python3-univention-directory-manager
COPY \
  libs/admin/license.py \
  libs/admin/password.py \
  ${DST_PY_LIBS}/univention/admin/

COPY \
  libs/config_registry.py \
  ${DST_PY_LIBS}/univention/config_registry.py

# from python3-univention-debug, univention package
COPY \
  libs/debug.py \
  ${DST_PY_LIBS}/univention/debug.py

COPY \
  scripts/entrypoint.sh \
  /entrypoint.sh


############################################################
# Define runtime

ENTRYPOINT ["/entrypoint.sh"]

CMD ["--no-daemon", "--debug=2", "--log-file=/dev/stdout"]

# [EOF]
