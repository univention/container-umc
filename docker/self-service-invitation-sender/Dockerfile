############################################################
# Global variables

ARG UCS_BASE_IMAGE_TAG=v0.7.2
ARG UCS_BASE_IMAGE=gitregistry.knut.univention.de/univention/components/ucs-base-image/ucs-base-505

############################################################
# Start first stage

FROM ${UCS_BASE_IMAGE}:${UCS_BASE_IMAGE_TAG} AS build

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

WORKDIR /apt

############################################################
# Install scripts and configs for dpkg

# COPY scripts/fake.sh /usr/local/bin/systemctl
# COPY scripts/fake.sh /usr/local/bin/a2dissite
# COPY scripts/fake.sh /usr/local/bin/call_joinscript
# COPY scripts/fake.sh /usr/local/bin/create_logfile
# COPY scripts/fake.sh /usr/local/bin/stop_udm_cli_server
# COPY scripts/fake.sh /usr/local/bin/umc_frontend_new_hash
# COPY scripts/fake.sh /usr/sbin/univention-management-console-acls
# COPY scripts/fake-uv-lib.sh /usr/local/bin/fake-uv-lib.sh

RUN \
  # For apt-get download sandbox
  chown _apt /apt && \
  apt-get --quiet update && \
  # install Python dependencies
  DEBIAN_FRONTEND=noninteractive \
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
            --option Dpkg::Options::="--force-confold" \
      python3=3.7.* \
      python3-distutils=3.7.* \
      patch=2.* \
      # for python3-univention
      python3-ldap=3.* \
      # for /usr/sbin/univention-config-registry
      python3-lazy-object-proxy=1.3.* \
      # the python3-univention-debug postinst uses py3compile
      python3-minimal=3.7.* \
      # for /usr/lib/univention-self-service-master/univention-self-service-invitation
      python3-six=1.12.* \
      && \
  apt-get download \
    # UV packages
    libunivention-config0=15.* \
    libunivention-debug1=12.* \
    python3-univention=13.* \
    python3-univention-debug=12.* \
    python3-univention-config-registry=15.* \
    python3-univention-lib=9.* \
    # for /usr/lib/univention-self-service-master/univention-self-service-invitation
    univention-self-service-invitation=5.* \
    && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
  DEBIAN_FRONTEND=noninteractive \
    dpkg --install --force-depends /apt/* && \
  rm -rf /apt/ && \
  awk \
    '/^Package: univention-self-service-invitation$/{ while(!/^Version: /){getline} print $2 }' \
    /var/lib/dpkg/status > /version

COPY 50-entrypoint.sh /entrypoint.d/50-entrypoint.sh

CMD [ "/usr/lib/univention-self-service-master/univention-self-service-invitation" ]
