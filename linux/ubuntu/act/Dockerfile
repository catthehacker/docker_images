ARG IMAGE=buildpack-deps
ARG TAG=20.04
FROM ${IMAGE}:${TAG}

# > automatic buildx ARGs
ARG TARGETARCH
ARG TARGETVARIANT

# > ARGs before FROM are not accessible
ARG IMAGE=buildpack-deps
ARG TAG=20.04

# > NodeJS version
ARG NODE_VERSION=12

# > Force apt to not be interactive/not ask
ARG DEBIAN_FRONTEND=noninteractive

SHELL [ "/bin/bash", "--noprofile", "--norc", "-e", "-o", "pipefail", "-c" ]

# > setup environment required for GitHub Actions
RUN set -Eeuxo pipefail \
    && printf "\n\n\t🐋\t Build started \t🐋\t\n\n" \
    && echo "USER=$(whoami)" | tee -a /etc/environment \
    && echo "RUNNER_USER=$(whoami)" | tee -a /etc/environment \
    && ImageOS=ubuntu$(echo ${TAG} | cut -d'.' -f 1) \
    && echo "IMAGE_OS=$ImageOS" | tee -a /etc/environment \
    && echo "ImageOS=$ImageOS" | tee -a /etc/environment \
    && echo "LSB_RELEASE=${TAG}" | tee -a /etc/environment \
    && AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache \
    && echo "AGENT_TOOLSDIRECTORY=$AGENT_TOOLSDIRECTORY" | tee -a /etc/environment \
    && echo "RUN_TOOL_CACHE=$AGENT_TOOLSDIRECTORY" | tee -a /etc/environment \
    && echo "DEPLOYMENT_BASEPATH=/opt/runner" | tee -a /etc/environment \
    && echo ". /etc/environment" | tee -a /etc/profile \
    && mkdir -p $AGENT_TOOLSDIRECTORY \
    && chown 1000:1000 $AGENT_TOOLSDIRECTORY \
    && chmod 0777 $AGENT_TOOLSDIRECTORY \
    && mkdir -p /github \
    && chown 1000:1000 /github \
    && chmod 0777 /github \
    && printf "\n\n\t🐋\t Installing packages \t🐋\t\n\n" \
    && apt-get -yq update \
    && apt-get -yq install --no-install-recommends ssh lsb-release gawk jq curl git wget sudo gnupg-agent ca-certificates software-properties-common apt-transport-https libyaml-0-2 zstd unzip xz-utils "$(apt-cache search libicu | grep -E 'libicu[[:digit:]]+ -' | cut -d \" \" -f 1)" \
    && ln -s $(which python3) /usr/local/bin/python \
    && [[ "${TAG}" == "16.04" ]] && printf 'git-lfs not available for Xenial' || apt-get -yq install --no-install-recommends git-lfs \
    && printf "\n\n\t🐋\t Updated apt lists and upgraded packages \t🐋\t\n\n" \
    && printf "\n\n\t🐋\t Creating ~/.ssh and adding 'github.com' \t🐋\t\n\n" \
    && mkdir -p ~/.ssh \
    && chmod 700 ~/.ssh \
    && ssh-keyscan github.com | tee ~/.ssh/known_hosts \
    && printf "\n\n\t🐋\t Installed base utils\nInstalling docker \t🐋\t\n\n" \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get -yq update \
    && apt-get -yq install --no-install-recommends docker-ce-cli \
    && printf "\n\n\t🐋\t Installed $(docker -v)\n \t🐋\t\n\n" \
    && printf "\n\n\t🐋\t Installing Node.JS \t🐋\t\n\n" \
    && curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && DISTRO="$(lsb_release -s -c)" \
    && echo "deb https://deb.nodesource.com/node_${NODE_VERSION}.x $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list \
    && echo "deb-src https://deb.nodesource.com/node_${NODE_VERSION}.x $DISTRO main" | tee -a /etc/apt/sources.list.d/nodesource.list \
    && apt-get -yq update \
    && apt-get -yq install --no-install-recommends nodejs="${NODE_VERSION}*" \
    && printf "\n\n\t🐋\t Installed Node.JS $(node -v) \t🐋\t\n\n" \
    && dpkg-query -f '${binary:Package}\n' -W \
    && printf "\n\n\t🐋\t Cleaning image \t🐋\t\n\n" \
    && apt-get clean \
    && rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/* /tmp/* || echo 'Failed to delete directories' \
    && printf "\n\n\t🐋\t Cleaned up image \t🐋\t\n\n"

ARG BUILD_TAG_VERSION="dev"
ARG BUILD_TAG="act"
ARG BUILD_REF="master"

LABEL org.opencontainers.image.vendor="catthehacker"
LABEL org.opencontainers.image.authors="me@hackerc.at"
LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images/tree/${BUILD_REF}/linux/${IMAGE}/${BUILD_TAG}/"
LABEL org.opencontainers.image.source="https://github.com/catthehacker/docker_images"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}-${TARGETARCH}-${TARGETVARIANT}
LABEL org.opencontainers.image.revision=${BUILD_REF}

USER root
