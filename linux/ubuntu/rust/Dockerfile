ARG IMAGE=ghcr.io/catthehacker/alpine
ARG TAG=act-latest
FROM ${IMAGE}:${TAG}

ARG TARGETARCH
ARG TARGETVARIANT

SHELL [ "/bin/bash", "--noprofile", "--norc", "-e", "-o", "pipefail", "-c" ]
RUN set -euxo pipefail \
    && printf "Installing Rust\n" \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y

ARG BUILD_TAG_VERSION="dev"
ARG BUILD_TAG="rust"
ARG BUILD_REF="master"

LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images/tree/${BUILD_REF}/linux/${ImageOS}/${BUILD_TAG}/"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}-${TARGETARCH}-${TARGETVARIANT}
LABEL org.opencontainers.image.revision=${BUILD_REF}
