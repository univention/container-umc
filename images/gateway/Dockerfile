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
      # for /etc/apache2/sites-available/univention-saml.conf
      univention-saml=7.* \
      # for /etc/apache2/sites-available/univention-portal.conf
      univention-portal=4.* \
      # for /etc/apache2/sites-available/univention-server-overview.conf
      univention-server-overview=3.* \
      univention-web-js=4.* \
      univention-web-style=4.* \
      && \
  rm -rf /var/lib/apt/lists/*


############################################################
# Start second stage

FROM ${DOCKER_REGISTRY}httpd:2.4 AS final

SHELL ["/bin/sh", "-eux", "-c"]

WORKDIR /

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get --assume-yes --no-install-recommends install \
      libpython3.7=3.7.* \
      libapache2-mod-wsgi-py3=4.6.* \
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
  /etc/univention/registry.info/ \
  /etc/univention/registry.info

COPY --from=build \
  /var/www \
  /var/www

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
  /etc/apache2/ucs-sites.conf.d \
  /etc/apache2/ucs-sites.conf.d

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

COPY --from=build \
  /etc/apache2/sites-available/ \
  /etc/apache2/sites-available

COPY --from=build \
  /etc/apache2/sites-enabled/ \
  /etc/apache2/sites-enabled


############################################################
# Copy Docker-specific files

RUN \
  mkdir -p \
  /usr/lib/apache2/modules/

# Disable configs
RUN \
  rm \
    /etc/apache2/conf-enabled/other-vhosts-access-log.conf

# Disable sites
RUN \
  rm \
    /etc/apache2/sites-available/univention-vhosts.conf

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
# @todo: if necessary install missing module /usr/lib/apache2/modules/mod_authnz_pam.so
RUN \
  rm \
    /etc/apache2/mods-enabled/authnz_pam.load

# Make modules available
# @todo: Not all modules are necessary!
RUN \
  ln -sf /usr/local/apache2/modules/mod_access_compat.so \
  /usr/lib/apache2/modules/mod_access_compat.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_actions.so \
  /usr/lib/apache2/modules/mod_actions.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_alias.so \
  /usr/lib/apache2/modules/mod_alias.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_auth_basic.so \
  /usr/lib/apache2/modules/mod_auth_basic.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_authn_core.so \
  /usr/lib/apache2/modules/mod_authn_core.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_authn_file.so \
  /usr/lib/apache2/modules/mod_authn_file.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_authz_core.so \
  /usr/lib/apache2/modules/mod_authz_core.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_authz_groupfile.so \
  /usr/lib/apache2/modules/mod_authz_groupfile.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_authz_host.so \
  /usr/lib/apache2/modules/mod_authz_host.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_authz_user.so \
  /usr/lib/apache2/modules/mod_authz_user.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_autoindex.so \
  /usr/lib/apache2/modules/mod_autoindex.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_cgi.so \
  /usr/lib/apache2/modules/mod_cgi.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_deflate.so \
  /usr/lib/apache2/modules/mod_deflate.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_dir.so \
  /usr/lib/apache2/modules/mod_dir.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_env.so \
  /usr/lib/apache2/modules/mod_env.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_expires.so \
  /usr/lib/apache2/modules/mod_expires.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_filter.so \
  /usr/lib/apache2/modules/mod_filter.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_headers.so \
  /usr/lib/apache2/modules/mod_headers.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_lbmethod_bybusyness.so \
  /usr/lib/apache2/modules/mod_lbmethod_bybusyness.so
RUN \
  ln -sf /usr/local/apache2/modules/mime.load \
  /usr/lib/apache2/modules/mime.load
RUN \
  ln -sf /usr/local/apache2/modules/mod_mpm_prefork.so \
  /usr/lib/apache2/modules/mod_mpm_prefork.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_negotiation.so \
  /usr/lib/apache2/modules/mod_negotiation.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_proxy_balancer.so \
  /usr/lib/apache2/modules/mod_proxy_balancer.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_proxy_connect.so \
  /usr/lib/apache2/modules/mod_proxy_connect.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_proxy_http.so \
  /usr/lib/apache2/modules/mod_proxy_http.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_proxy.so \
  /usr/lib/apache2/modules/mod_proxy.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_reqtimeout.so \
  /usr/lib/apache2/modules/mod_reqtimeout.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_rewrite.so \
  /usr/lib/apache2/modules/mod_rewrite.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_setenvif.so \
  /usr/lib/apache2/modules/mod_setenvif.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_slotmem_shm.so \
  /usr/lib/apache2/modules/mod_slotmem_shm.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_socache_shmcb.so \
  /usr/lib/apache2/modules/mod_socache_shmcb.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_ssl.so \
  /usr/lib/apache2/modules/mod_ssl.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_status.so \
  /usr/lib/apache2/modules/mod_status.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_suexec.so \
  /usr/lib/apache2/modules/mod_suexec.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_unique_id.so \
  /usr/lib/apache2/modules/mod_unique_id.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_mime.so \
  /usr/lib/apache2/modules/mod_mime.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_mpm_event.so \
  /usr/lib/apache2/modules/mod_mpm_event.so
RUN \
  ln -sf /usr/local/apache2/modules/mod_log_config.so \
  /usr/lib/apache2/modules/mod_log_config.so

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
  /etc/apache2/ucs-sites.conf.d/ucs-sites.conf

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
