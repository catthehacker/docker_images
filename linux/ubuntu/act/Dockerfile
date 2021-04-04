ARG DISTRIB_ID=ubuntu
ARG DISTRIB_RELEASE=20.04
FROM ${DISTRIB_ID}:${DISTRIB_RELEASE}

# > ARGs before FROM are not accessible
ARG DISTRIB_ID=ubuntu
ARG DISTRIB_RELEASE=20.04

# > Node version
ARG NODE_VERSION=12

# > Force apt to not be interactive/not ask
ARG DEBIAN_FRONTEND=noninteractive

SHELL [ "/bin/bash", "-c" ]

# > setup environment required for GitHub Actions
RUN set -Eeuxo pipefail \
    && printf "Build started\n" \
    && echo "USER=$(whoami)" | tee -a /etc/environment \
    && echo "RUNNER_USER=$(whoami)" | tee -a /etc/environment \
    && ImageOS=${DISTRIB_ID}$(echo ${DISTRIB_RELEASE} | cut -d'.' -f 1) \
    && echo "IMAGE_OS=$ImageOS" | tee -a /etc/environment \
    && echo "ImageOS=$ImageOS" | tee -a /etc/environment \
    && echo "LSB_RELEASE=${DISTRIB_RELEASE}" | tee -a /etc/environment \
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
    && chmod 0777 /github

# > Install deps
RUN set -Eeuxo pipefail \
    && apt -yq update \
    && printf "Updated apt lists and upgraded packages\n\n" \
    && apt -yq install --no-install-recommends ssh lsb-release gawk jq curl git wget sudo gnupg-agent ca-certificates software-properties-common apt-transport-https libyaml-0-2 zstd unzip xz-utils $(apt-cache search libicu | grep -E 'libicu[[:digit:]]+ -' | cut -d " " -f 1) \
    && printf "Installed base utils\nInstalling docker\n" \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt -yq update \
    && apt -yq install docker-ce-cli \
    && printf "Cleaning image\n" \
    && apt-get clean \
    && rm -rf /var/cache/* \
    && rm -rf /var/log/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && printf "Cleaned up image\n"

# > Install Node.JS
RUN set -Eeuxo pipefail \
    && printf "Installing Node.JS\n" \
    && curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && DISTRO="$(lsb_release -s -c)" \
    && echo "deb https://deb.nodesource.com/node_${NODE_VERSION}.x $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list \
    && echo "deb-src https://deb.nodesource.com/node_${NODE_VERSION}.x $DISTRO main" | tee -a /etc/apt/sources.list.d/nodesource.list \
    && apt -yq update \
    && apt -yq install --no-install-recommends nodejs="${NODE_VERSION}*" \
    && printf "Installed Node.JS $(node -v)\n" \
    && dpkg-query -f '${binary:Package}\n' -W \
    && printf "Cleaning image\n" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && printf "Cleaned up image\n"

ARG BUILD_TAG_VERSION="master"
ARG BUILD_TAG="act"
ARG BUILD_REF="master"

LABEL org.opencontainers.image.vendor="catthehacker"
LABEL org.opencontainers.image.authors="me@hackerc.at"
LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images"
LABEL org.opencontainers.image.source="https://github.com/catthehacker/docker_images.git"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}
LABEL org.opencontainers.image.revision=${BUILD_REF}

USER root

SHELL [ "/bin/bash", "--login", "-c" ]

# > Force bash with environment
ENTRYPOINT [ "/bin/bash", "--login", "-c" ]
