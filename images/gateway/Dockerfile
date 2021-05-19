############################################################
# Global variables

ARG DOCKER_REGISTRY=""

############################################################
# Set Docker environment

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


############################################################
# Install univention-management-console-frontend / univention-web

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
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
  rm -rf /var/lib/apt/lists/*


############################################################
# Start second stage

FROM ${DOCKER_REGISTRY}httpd:2.4 AS final

ARG SRC_PY_LIBS="/usr/lib/python3/dist-packages"
ARG DST_PY_LIBS="/usr/lib/python3/dist-packages"

SHELL ["/bin/sh", "-eux", "-c"]

WORKDIR /

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
      libpython3.7=3.7.* \
      libapache2-mod-wsgi-py3=4.6.* \
      # for univention-config-registry
      python3-lazy-object-proxy=1.3.* \
      python3-six=1.12.* \
      && \
  rm -rf /var/lib/apt/lists/*


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
  /usr/share/doc/univention-web-style/ \
  /usr/share/doc/univention-web-style

COPY --from=build \
  /usr/share/doc/univention-web-js/ \
  /usr/share/doc/univention-web-js

COPY --from=build \
  ${SRC_PY_LIBS}/univention/debhelper.py \
  ${DST_PY_LIBS}/univention/debhelper.py

COPY --from=build \
  ${SRC_PY_LIBS}/univention/lib/misc.py \
  ${DST_PY_LIBS}/univention/lib/misc.py

RUN touch ${DST_PY_LIBS}/univention/lib/__init__.py

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

RUN mkdir --parents /var/cache/univention-config/ && \
  touch /var/cache/univention-config/cache

RUN mkdir /var/log/univention/

COPY --from=build \
  /etc/univention/templates/info/univention-management-console-server.info \
  /etc/univention/templates/info/univention-web-js.info \
  /etc/univention/templates/info/univention-apache.info \
  /etc/univention/templates/info/univention-directory-manager-rest.info \
  /etc/univention/templates/info/univention-management-console-web-server.info \
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
# Copy Docker-specific files

RUN \
  mkdir -p \
  /usr/lib/apache2/modules/

# Disable configs
RUN \
  rm \
    /etc/apache2/conf-enabled/other-vhosts-access-log.conf \
    /etc/apache2/conf-available/simplesamlphp.conf \
    /etc/apache2/conf-available/php7.3-cgi.conf

# Enable modules
RUN \
  echo "LoadModule unixd_module /usr/local/apache2/modules/mod_unixd.so" \
  > /etc/apache2/mods-enabled/unixd.load
RUN \
  echo "LoadModule log_config_module /usr/local/apache2/modules/mod_log_config.so" \
  > /etc/apache2/mods-enabled/log_config.load
RUN \
  ln -sf /etc/apache2/mods-available/proxy_http.load \
  /etc/apache2/mods-enabled/proxy_http.load

# Disable modules
RUN for mod in \
  authnz_pam \
  mod_actions \
  mod_cgi \
  mod_suexec \
  ; do \
    rm "/etc/apache2/mods-enabled/${mod}.load" || true; \
  done

# Make modules available
# @todo: Not all modules are necessary!
RUN for mod in \
  mod_access_compat \
  mod_alias \
  mod_auth_basic \
  mod_authn_core \
  mod_authn_file \
  mod_authz_core \
  mod_authz_groupfile \
  mod_authz_host \
  mod_authz_user \
  mod_autoindex \
  mod_deflate \
  mod_dir \
  mod_env \
  mod_expires \
  mod_filter \
  mod_headers \
  mod_lbmethod_bybusyness \
  mime.load \
  mod_mpm_prefork \
  mod_negotiation \
  mod_proxy_balancer \
  mod_proxy_connect \
  mod_proxy_http \
  mod_proxy \
  mod_reqtimeout \
  mod_rewrite \
  mod_setenvif \
  mod_slotmem_shm \
  mod_socache_shmcb \
  mod_ssl \
  mod_status \
  mod_unique_id \
  mod_mime \
  mod_mpm_event \
  mod_log_config \
  ; do \
    ln -sf "/usr/local/apache2/modules/${mod}.so" \
    "/usr/lib/apache2/modules/${mod}.so"; \
  done

# Change/Remove some properties in the default univention apache config
RUN \
  sed -i "/User \${APACHE_RUN_USER}/c User www-data" \
  /etc/apache2/apache2.conf
RUN \
  sed -i "/Group \${APACHE_RUN_GROUP}/c Group www-data" \
  /etc/apache2/apache2.conf
RUN \
  sed -i "/\${APACHE_RUN_DIR}/d" \
  /etc/apache2/apache2.conf
RUN \
  sed -i "/ErrorLog \${APACHE_LOG_DIR}/c ErrorLog /dev/stderr" \
  /etc/apache2/apache2.conf
RUN \
  sed -i "/PidFile \${APACHE_PID_FILE}/c PidFile /usr/local/apache2/logs/httpd.pid" \
  /etc/apache2/apache2.conf
# Custom Log format (example): CustomLog "/dev/stdout" "%h %l %u %t \"%r\" %>s %b"
RUN \
  sed -i '/CustomLog \/var\/log\/apache2\/access.log/c CustomLog \"\/dev\/stdout\" "\%h \%l \%u \%t \\"\%r\\" \%>s \%b"' \
  /etc/univention/templates/files/etc/apache2/ucs-sites.conf.d/ucs-sites.conf

# Change LogFormat temporarily
# Replace \%O to \%b in LogFormat
RUN \
  sed -i '/LogFormat/s/\%O/\%b/g' \
  /etc/apache2/apache2.conf

COPY \
  scripts/entrypoint.sh \
  /entrypoint.sh


############################################################
# Define runtime

ENTRYPOINT ["/entrypoint.sh"]

CMD ["-D", \
     "FOREGROUND", \
     "-d", "/etc/apache2/", \
     "-f", "/etc/apache2/apache2.conf"]

# [EOF]
