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


############################################################
# Define runtime

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["--no-dameon", "-d", "2", "-L", "/dev/stdout"]

# [EOF]
