ARG IMAGE=ghcr.io/catthehacker/alpine
ARG TAG=act-latest
FROM ${IMAGE}:${TAG}

ARG TARGETARCH
ARG TARGETVARIANT

SHELL [ "/bin/bash", "--noprofile", "--norc", "-e", "-o", "pipefail", "-c" ]

RUN set -Eeuxo pipefail \
    && printf "Installing Go(lang)\n" \
    && sudo apk add --no-cache go

ARG BUILD_TAG_VERSION="dev"
ARG BUILD_TAG="go"
ARG BUILD_REF="master"

LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images/tree/${BUILD_REF}/linux/${ImageOS}/${BUILD_TAG}/"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}-${TARGETARCH}-${TARGETVARIANT}
LABEL org.opencontainers.image.revision=${BUILD_REF}
