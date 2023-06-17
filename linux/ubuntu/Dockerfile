ARG FROM_IMAGE
ARG FROM_TAG
FROM ${FROM_IMAGE}:${FROM_TAG}

# > automatic buildx ARGs
ARG TARGETARCH

# > ARGs before FROM are not accessible
ARG FROM_IMAGE
ARG FROM_TAG

# > Our custom ARGs
# latest Node.js LTS versions
ARG NODE_VERSION="16 18"
ARG DISTRO=ubuntu
ARG TYPE=act
ARG RUNNER

# > Force apt to not be interactive/not ask
ENV DEBIAN_FRONTEND=noninteractive

SHELL [ "/bin/bash", "--login", "-e", "-o", "pipefail", "-c" ]
WORKDIR /tmp

COPY ./linux/${DISTRO}/scripts /imagegeneration/installers
RUN /imagegeneration/installers/${TYPE}.sh

ARG BUILD_DATE
ARG BUILD_TAG=${TYPE}
ARG BUILD_REF
ARG BUILD_TAG_VERSION
ARG BUILD_OWNER
ARG BUILD_REPO

LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.vendor="${BUILD_OWNER}"
LABEL org.opencontainers.image.authors="https://github.com/${BUILD_OWNER}"
LABEL org.opencontainers.image.url="https://github.com/${BUILD_OWNER}/${BUILD_REPO}/tree/${BUILD_REF}/linux/${DISTRO}/${TYPE}/"
LABEL org.opencontainers.image.source="https://github.com/${BUILD_OWNER}/${BUILD_REPO}"
LABEL org.opencontainers.image.documentation="https://github.com/${BUILD_OWNER}/${BUILD_REPO}"
LABEL org.opencontainers.image.version="${BUILD_TAG_VERSION}"
LABEL org.opencontainers.image.title="${BUILD_TAG}-${TARGETARCH}"
LABEL org.opencontainers.image.description="Special image built for using with https://github.com/nektos/act"
LABEL org.opencontainers.image.revision="${BUILD_REF}"

USER ${RUNNER}
