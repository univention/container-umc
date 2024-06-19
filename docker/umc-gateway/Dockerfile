# SPDX-License-Identifier: AGPL-3.0-only
# SPDX-FileCopyrightText: 2024 Univention GmbH

############################################################
# Global variables

ARG UCS_BASE_IMAGE_TAG=0.13.0-build-2024-06-18
ARG UCS_BASE_IMAGE=gitregistry.knut.univention.de/univention/components/ucs-base-image/ucs-base-508

ARG PORTAL_EXTENSION_IMAGE=gitregistry.knut.univention.de/univention/components/univention-portal/portal-extension
ARG PORTAL_EXTENSION_TAG=0.26.0

FROM ${PORTAL_EXTENSION_IMAGE}:${PORTAL_EXTENSION_TAG} AS portal-extension

############################################################
# First build stage

FROM ${UCS_BASE_IMAGE}:${UCS_BASE_IMAGE_TAG} AS build

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

WORKDIR /apt

############################################################
# Install scripts and configs for dpkg

COPY scripts/fake.sh /usr/local/bin/systemctl
COPY scripts/fake.sh /usr/local/bin/call_joinscript
COPY scripts/fake.sh /usr/local/bin/create_logfile
COPY scripts/fake.sh /usr/local/bin/stop_udm_cli_server
COPY scripts/fake.sh /usr/local/bin/umc_frontend_new_hash
COPY scripts/fake-uv-lib.sh /usr/local/bin/fake-uv-lib.sh

############################################################
# Install univention-management-console-frontend / univention-web

# hadolint ignore=SC2016
RUN \
  # install Univention bash helper functions dependency
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
      shell-univention-lib=9.* \
      && \
  # install unlisted dependencies
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
      python3=3.7.* \
      python3-distutils=3.7.* \
      && \
  # install UMC
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
            --option Dpkg::Options::="--force-confold" \
      univention-apache=12.* \
      # also for /etc/apache2/sites-available/univention-udm.conf
      univention-directory-manager-rest=10.* \
      univention-management-console-login=12.* \
      univention-management-console-frontend=12.* \
      # for /etc/apache2/sites-available/univention.conf
      univention-management-console-web-server=12.* \
      # for /etc/univention/templates/files/var/www/univention/meta.json
      univention-management-console-server=12.* \
      # for /usr/share/univention-management-console-frontend/js/dijit/themes/umc/icons/scalable/.*
      univention-saml=7.* \
      # for /usr/share/univention-management-console-frontend/js/dijit/themes/umc/icons/scalable/.*
      univention-portal=4.* \
      # for /etc/apache2/sites-available/univention-server-overview.conf
      univention-server-overview=3.* \
      univention-web-js=4.* \
      univention-web-style=4.* \
      # for /usr/sbin/univention-config-registry
      python3-univention-config-registry=15.* \
      univention-config=15.* \
      python3-univention-debhelper=2.* \
      # for UCR template files
      python3-univention-lib=9.* \
      && \
  # install self-service files (avoid pulling in postfix, postgres, ...)
    apt-get download \
      univention-self-service=5.* \
      univention-self-service-master=5.* \
      # for /etc/univention/templates/files/etc/apache2/sites-available/univention-self-service.conf
      # and /usr/share/univention-management-console-frontend/js/umc/modules/passwordreset.js
      univention-self-service-passwordreset-umc=5.* \
      && \
    DEBIAN_FRONTEND=noninteractive \
    dpkg --install --force-depends /apt/* && \
  rm -rf /apt/ \
  awk \
    '/^Package: python3-univention-directory-manager-rest$/{ while(!/^Version: /){getline} print $2 }' \
    /var/lib/dpkg/status > /version

############################################################
# Start second stage

FROM ${UCS_BASE_IMAGE}:${UCS_BASE_IMAGE_TAG} AS final

ARG LABEL_CREATED=undefined
ARG LABEL_REVISION=undefined
ARG LABEL_SOURCE=undefined
ARG LABEL_VERSION=undefined
ARG SRC_PY_LIBS="/usr/lib/python3/dist-packages"
ARG DST_PY_LIBS="/usr/lib/python3/dist-packages"

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

WORKDIR /

RUN \
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
      libpython3.7=3.7.* \
      libapache2-mod-wsgi-py3=4.* \
      # for univention-config-registry
      python3-lazy-object-proxy=1.* \
      python3-six=1.* \
      apache2-bin=2.*


############################################################
# Copy files from first stage

COPY --from=build \
  /usr/share/univention-web/ \
  /usr/share/univention-web

COPY --from=build \
  /usr/share/univention-management-console/ \
  /usr/share/univention-management-console

COPY --from=build \
  /usr/share/univention-management-console-login/ \
  /usr/share/univention-management-console-login

COPY --from=build \
  /usr/share/doc/univention-management-console-login/ \
  /usr/share/doc/univention-management-console-login

COPY --from=build \
  /usr/share/univention-management-console-frontend/ \
  /usr/share/univention-management-console-frontend

COPY --from=build \
  /usr/share/doc/univention-management-console-frontend/ \
  /usr/share/doc/univention-management-console-frontend

COPY --from=build \
  /usr/share/univention-self-service/www/ \
  /usr/share/univention-self-service/www

COPY --from=build \
  /usr/share/doc/univention-web-style/ \
  /usr/share/doc/univention-web-style

COPY --from=build \
  /usr/share/doc/univention-web-js/ \
  /usr/share/doc/univention-web-js

COPY --from=build \
  ${SRC_PY_LIBS}/univention/ \
  ${DST_PY_LIBS}/univention/

COPY --from=build \
  /usr/sbin/univention-config-registry \
  /usr/sbin/univention-config-registry

COPY --from=build \
  /version \
  /version

RUN \
  ln --symbolic --force /usr/sbin/univention-config-registry /usr/sbin/ucr && \
  \
  mkdir --parents /var/cache/univention-config/ && \
  touch /var/cache/univention-config/cache && \
  \
  mkdir /var/log/univention/

COPY --from=build \
  /etc/univention/templates/info/univention-management-console-server.info \
  /etc/univention/templates/info/univention-web-js.info \
  /etc/univention/templates/info/univention-apache.info \
  /etc/univention/templates/info/univention-directory-manager-rest.info \
  /etc/univention/templates/info/univention-management-console-web-server.info \
  /etc/univention/templates/info/univention-self-service-passwordreset-umc.info \
  /etc/univention/templates/info/univention-server-overview.info \
  /etc/univention/templates/info/

COPY --from=build \
  /etc/univention/templates/files/var/www/univention/meta.json \
  /etc/univention/templates/files/var/www/univention/languages.json \
  /etc/univention/templates/files/var/www/univention/

COPY --from=build \
  /etc/univention/templates/files/etc/apache2/mods-available/proxy.conf \
  /etc/univention/templates/files/etc/apache2/mods-available/ssl.conf \
  /etc/univention/templates/files/etc/apache2/mods-available/

COPY --from=build \
  /etc/univention/templates/files/etc/apache2/conf-available/ucs.conf \
  /etc/univention/templates/files/etc/apache2/conf-available/univention-web.conf \
  /etc/univention/templates/files/etc/apache2/conf-available/

RUN mkdir --parents /etc/apache2/sites-enabled/

COPY --from=build \
  /etc/univention/templates/files/etc/apache2/sites-available/univention.conf \
  /etc/univention/templates/files/etc/apache2/sites-available/univention.conf
RUN ln -sf /etc/apache2/sites-available/univention.conf /etc/apache2/sites-enabled/univention.conf

COPY --from=build \
  /etc/univention/templates/files/etc/apache2/sites-available/univention-udm.conf \
  /etc/univention/templates/files/etc/apache2/sites-available/univention-udm.conf
RUN ln --symbolic --force /etc/apache2/sites-available/univention-udm.conf \
                          /etc/apache2/sites-enabled/univention-udm.conf
COPY --from=build \
  /etc/univention/templates/files/etc/apache2/sites-available/univention-server-overview.conf \
  /etc/univention/templates/files/etc/apache2/sites-available/univention-server-overview.conf
RUN ln -sf /etc/apache2/sites-available/univention-server-overview.conf /etc/apache2/sites-enabled/univention-server-overview.conf

COPY --from=build \
  /etc/univention/templates/files/etc/apache2/sites-available/univention-self-service.conf \
  /etc/univention/templates/files/etc/apache2/sites-available/univention-self-service.conf
RUN ln -sf /etc/apache2/sites-available/univention-self-service.conf /etc/apache2/sites-enabled/univention-self-service.conf

COPY --from=build \
  /etc/univention/templates/files/etc/apache2/sites-available/ssl.d/00start \
  /etc/univention/templates/files/etc/apache2/sites-available/ssl.d/10hsts \
  /etc/univention/templates/files/etc/apache2/sites-available/ssl.d/99end \
  /etc/univention/templates/files/etc/apache2/sites-available/ssl.d/

RUN ln -sf /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf

COPY --from=build \
  /etc/univention/templates/files/etc/apache2/sites-available/000-default.d/00start \
  /etc/univention/templates/files/etc/apache2/sites-available/000-default.d/99end \
  /etc/univention/templates/files/etc/apache2/sites-available/000-default.d/

RUN ln -sf /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf

COPY --from=build \
  /etc/univention/templates/files/etc/apache2/ucs-sites.conf.d/ucs-sites.conf \
  /etc/univention/templates/files/etc/apache2/ucs-sites.conf.d/ucs-sites.conf

COPY --from=build \
  /etc/univention/templates/files/etc/apache2/ports.conf \
  /etc/univention/templates/files/etc/apache2/ports.conf

COPY --from=build \
  /etc/univention/*.conf \
  /etc/univention/

COPY --from=build \
  /etc/univention/templates/scripts/symlink-web-theme.sh \
  /etc/univention/templates/scripts/symlink-web-theme.sh

COPY --from=build \
  /var/www \
  /var/www
RUN rm -rf /var/www/saml

COPY --from=build \
  /etc/apache2/apache2.conf \
  /etc/apache2/

COPY --from=build \
  /etc/mime.types \
  /etc/

COPY --from=build \
  /etc/apache2/magic \
  /etc/apache2/

COPY --from=build \
  /etc/apache2/ports.conf \
  /etc/apache2/

COPY --from=build \
  /etc/apache2/conf-available/ \
  /etc/apache2/conf-available

COPY --from=build \
  /etc/apache2/conf-enabled/ \
  /etc/apache2/conf-enabled

COPY --from=build \
  /etc/apache2/mods-available/ \
  /etc/apache2/mods-available

COPY --from=build \
  /etc/apache2/mods-enabled/ \
  /etc/apache2/mods-enabled


############################################################
# Add files from the portal extension

COPY --from=portal-extension /plugins/umc-icons/ \
    /usr/share/univention-management-console-frontend/js/dijit/themes/umc/icons/


############################################################
# Copy Docker-specific files

RUN \
  mkdir -p \
  /usr/lib/apache2/modules/ && \
  # Disable configs
  rm \
    /etc/apache2/conf-enabled/other-vhosts-access-log.conf \
    /etc/apache2/conf-available/simplesamlphp.conf \
    /etc/apache2/conf-available/php7.3-cgi.conf && \
  # Enable modules
  # echo "LoadModule unixd_module /usr/local/apache2/modules/mod_unixd.so" \
    # > /etc/apache2/mods-enabled/unixd.load && \
  # \
  # echo "LoadModule log_config_module /usr/local/apache2/modules/mod_log_config.so" \
    # > /etc/apache2/mods-enabled/log_config.load && \
  \
  ln -sf /etc/apache2/mods-available/proxy_http.load \
    /etc/apache2/mods-enabled/proxy_http.load && \
  \
  # Disable modules
  rm "/etc/apache2/mods-enabled/authnz_pam.load" && \
  \
  # Change/Remove some properties in the default univention apache config
  sed -i "/User \${APACHE_RUN_USER}/c User www-data" \
    /etc/apache2/apache2.conf && \
  sed -i "/Group \${APACHE_RUN_GROUP}/c Group www-data" \
    /etc/apache2/apache2.conf && \
  sed -i "/\${APACHE_RUN_DIR}/d" \
    /etc/apache2/apache2.conf && \
  sed -i "/ErrorLog \${APACHE_LOG_DIR}/c ErrorLog /dev/stderr" \
    /etc/apache2/apache2.conf && \
  sed -i "/PidFile \${APACHE_PID_FILE}/c PidFile /usr/local/apache2/logs/httpd.pid" \
    /etc/apache2/apache2.conf && \
  # Specify the Mutex implementation.
  # This choice allows running the amd64 container also on arm64 hosts.
  sed -i 's/^#\?Mutex.*$/Mutex posixsem/' \
    /etc/apache2/apache2.conf && \
  # Custom Log format (example): CustomLog "/dev/stdout" "%h %l %u %t \"%r\" %>s %b"
  sed -i '/CustomLog \/var\/log\/apache2\/access.log/c CustomLog \"\/dev\/stdout\" "\%h \%l \%u \%t \\"\%r\\" \%>s \%b"' \
    /etc/univention/templates/files/etc/apache2/ucs-sites.conf.d/ucs-sites.conf && \
  \
  # Change LogFormat temporarily
  # Replace \%O to \%b in LogFormat
  sed -i '/LogFormat/s/\%O/\%b/g' \
    /etc/apache2/apache2.conf && \
  \
  # Do not forward requests to the UMC server through here,
  # instead the ingress/istio needs to be configured properly.
  sed \
    --in-place \
    --expression='s#print.*ProxyPass.*auth|saml|get|set|command|upload|logout.*#pass#' \
    /etc/univention/templates/files/etc/apache2/sites-available/univention.conf && \
  # Do not forward requests to the UDM through here,
  # instead the ingress/istio needs to be configured properly.
  rm \
    /etc/univention/templates/files/etc/apache2/sites-available/univention-udm.conf \
    /etc/apache2/sites-enabled/univention-udm.conf && \
  mkdir --parents /usr/local/apache2/logs/

COPY \
  scripts/50-entrypoint.sh \
  scripts/60-umc-title.sh \
  /entrypoint.d/

############################################################
# Define runtime

CMD ["apache2", \
     "-D", \
     "FOREGROUND", \
     "-d", "/etc/apache2/", \
     "-f", "/etc/apache2/apache2.conf"]

# [EOF]
