ARG BASEIMAGE=catthehacker/alpine
ARG TAG=act
FROM ${BASEIMAGE}:${TAG}

SHELL [ "/bin/ash", "-o", "pipefail", "-l", "-c" ]

RUN set -Eeuxo pipefail \
    && printf "Installing Rust\n" \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y

ARG BUILD_TAG_VERSION="master"
ARG BUILD_TAG="rust"
ARG BUILD_REF="master"

LABEL org.opencontainers.image.vendor="catthehacker"
LABEL org.opencontainers.image.authors="me@hackerc.at"
LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images/tree/${BUILD_REF}/linux/${ImageOS}/${BUILD_TAG}/"
LABEL org.opencontainers.image.source="https://github.com/catthehacker/docker_images.git"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}-${TARGETARCH}-${TARGETVARIANT}
LABEL org.opencontainers.image.revision=${BUILD_REF}
