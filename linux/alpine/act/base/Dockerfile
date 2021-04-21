ARG BASEIMAGE=node
ARG TAG=lts-alpine3.13
FROM ${BASEIMAGE}:${TAG}

ARG TARGETARCH
ARG TARGETVARIANT

# > ARGs before FROM are not accessible
ARG BASEIMAGE=alpine
ARG TAG=3.13
ARG AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache
ARG IMAGE_TYPE=act
ENV ImageOS=alpine


SHELL [ "/bin/ash", "-o", "pipefail", "-l", "-c" ]

# > setup environment required for GitHub Actions, install dependencies/packages
RUN set -euxo pipefail \
    && printf "Build started\nAdding environment variables\n\n" \
    && echo "USER=$(whoami)" | tee -a /etc/environment \
    && echo "RUNNER_USER=$(whoami)" | tee -a /etc/environment \
    && echo "IMAGE_OS=${ImageOS}" | tee -a /etc/environment \
    && echo "ImageOS=${ImageOS}" | tee -a /etc/environment \
    #&& echo "LSB_RELEASE=${DISTRIB_RELEASE}" | tee -a /etc/environment \
    && echo "AGENT_TOOLSDIRECTORY=${AGENT_TOOLSDIRECTORY}" | tee -a /etc/environment \
    && echo "RUN_TOOL_CACHE=${AGENT_TOOLSDIRECTORY}" | tee -a /etc/environment \
    && echo "DEPLOYMENT_BASEPATH=/opt/runner" | tee -a /etc/environment \
    && echo ". /etc/environment" | tee -a /etc/profile \
    && printf "Creating tool cache directory and '/github'\n\n" \
    && mkdir -p ${AGENT_TOOLSDIRECTORY} \
    && chown 1000:1000 ${AGENT_TOOLSDIRECTORY} \
    && chmod 0777 ${AGENT_TOOLSDIRECTORY} \
    && mkdir -p /github \
    && chown 1000:1000 /github \
    && chmod 0777 /github \
    && printf "Installing packages\n\n" \
    && apk --no-cache add openssh-client gawk jq curl git wget sudo gnupg ca-certificates yaml zstd zip unzip xz icu build-base python3 \
    && printf "Creating ~/.ssh and adding 'github.com'\n\n" \
    && mkdir -p ~/.ssh \
    && chmod 700 ~/.ssh \
    && ssh-keyscan github.com | tee ~/.ssh/known_hosts \
    && printf "Installed base utils\nInstalling docker\n" \
    && apk --no-cache add docker-cli \
    && printf "Cleaning image\n" \
    && apk clean cache \
    && rm -rf /var/cache/* /var/log/* /tmp/* || echo 'Failed to delete directories' \
    && printf "Cleaned up image\n"

ARG BUILD_TAG_VERSION="master"
ARG BUILD_TAG=${IMAGE_TYPE}
ARG BUILD_REF="master"

LABEL org.opencontainers.image.vendor="catthehacker"
LABEL org.opencontainers.image.authors="me@hackerc.at"
LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images/tree/${BUILD_REF}/linux/${ImageOS}/${BUILD_TAG}/"
LABEL org.opencontainers.image.source="https://github.com/catthehacker/docker_images.git"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}-${TARGETARCH}-${TARGETVARIANT}
LABEL org.opencontainers.image.revision=${BUILD_REF}

SHELL [ "/bin/ash", "-l", "-c" ]

# > Force bash with environment
ENTRYPOINT [ "/bin/ash", "-l", "-c" ]
