ARG UCS_BASE_IMAGE_TAG=0.16.1-build-2025-02-20
ARG UCS_BASE_IMAGE=gitregistry.knut.univention.de/univention/components/ucs-base-image/ucs-base-520

FROM ${UCS_BASE_IMAGE}:${UCS_BASE_IMAGE_TAG} AS build

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

RUN apt-get --assume-yes --verbose-versions --no-install-recommends install ca-certificates

# NOTE: Install from testing to get the latest version of sssd
# RUN printf \
#     "deb [ allow-insecure=yes ] https://deb.debian.org/debian testing main\ndeb-src [ allow-insecure=yes ] https://deb.debian.org/debian testing main" \
#     > /etc/apt/sources.list.d/testing.list \
#     && apt-get --allow-unauthenticated update
#     && apt-get --assume-yes --verbose-versions --allow-unauthenticated --no-install-recommends install \
#     sssd=2.10.*

RUN getent group sssd >/dev/null || groupadd -r sssd \
    && getent passwd sssd >/dev/null || useradd -r -g sssd -d / -s /sbin/nologin -c "User for sssd" sssd

# NOTE: Dependencies needed for getting the source code and building (not included in the build-dep below)
RUN apt-get install --assume-yes --verbose-versions --allow-unauthenticated --no-install-recommends \
    wget \
    winbind \
    libcap-dev \
    && cp /usr/lib/x86_64-linux-gnu/samba/libidmap-private-samba.so.0 /usr/lib/x86_64-linux-gnu/samba/libidmap-private-samba.so

WORKDIR /sssd

RUN wget https://github.com/SSSD/sssd/releases/download/2.10.2/sssd-2.10.2.tar.gz \
    && apt-get build-dep --assume-yes --allow-unauthenticated sssd \
    && tar -xvf sssd-2.10.2.tar.gz \
    && cd sssd-2.10.2 \
    && ./configure \
    --with-sssd-user=sssd \
    # Other stuff we may not need
    --disable-krb5-locator-plugin \
    --disable-pac-responder \
    --disable-cifs-idmap-plugin \
    --without-python2-bindings \
    --without-autofs \
    --without-samba \
    --without-nfsv4-idmapd-plugin \
    --without-libwbclient \
    --without-libnl \
    --disable-nls \
    --disable-rpath \
    && make \
    && make install

# NOTE: Needed for `sssctl config-check`
RUN apt-get --assume-yes --verbose-versions --no-install-recommends install \
    libsss-certmap0 \
    # others
    libsss-sudo \
    libsss-idmap0 \
    libsss-nss-idmap0 \
    sssd-ldap

USER sssd

# sssd -i --logger stderr --debug-level 2
CMD ["sssd", "-i", "--logger", "stderr", "--debug-level", "2"]
