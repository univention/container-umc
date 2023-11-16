ARG LISTENER_BASE_IMAGE_TAG=v0.4.1
ARG LISTENER_BASE_IMAGE=gitregistry.knut.univention.de/univention/customers/dataport/upx/container-listener-base/listener-base:${LISTENER_BASE_IMAGE_TAG}

# hadolint ignore=DL3006
FROM ${LISTENER_BASE_IMAGE}

RUN \
    apt-get update && \
    apt-get --assume-yes --verbose-versions --no-install-recommends install \
        python3=3.7.* \
        univention-self-service-invitation=5.* \
        && \
    rm -fr /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    DEBIAN_FRONTEND=noninteractive \
        dpkg --install --force-depends /apt/* && \
    rm -rf /apt/

CMD ["/command.sh"]
