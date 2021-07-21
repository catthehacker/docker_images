ARG FROM_IMAGE
ARG FROM_TAG
FROM ${FROM_IMAGE}:${FROM_TAG}

# > automatic buildx ARGs
ARG TARGETARCH

# > ARGs before FROM are not accessible
ARG FROM_IMAGE
ARG FROM_TAG

# > Our custom ARGs
ARG NODE_VERSION=14
ARG DISTRO=ubuntu
ARG TYPE=act
ARG RUNNER=root

# > Force apt to not be interactive/not ask
ENV DEBIAN_FRONTEND=noninteractive

SHELL [ "/bin/bash", "--noprofile", "--norc", "-e", "-o", "pipefail", "-c" ]

COPY ./linux/${DISTRO}/scripts /imagegeneration/installers
RUN /imagegeneration/installers/${TYPE}.sh

ARG BUILD_TAG
ARG BUILD_REF="master"
ARG BUILD_TAG_VERSION="dev"

LABEL org.opencontainers.image.vendor="catthehacker"
LABEL org.opencontainers.image.authors="me@hackerc.at"
LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images/tree/${BUILD_REF}/linux/${DISTRO}/${TYPE}/"
LABEL org.opencontainers.image.source="https://github.com/catthehacker/docker_images"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}-${TARGETARCH}
LABEL org.opencontainers.image.revision=${BUILD_REF}

USER ${RUNNER}
