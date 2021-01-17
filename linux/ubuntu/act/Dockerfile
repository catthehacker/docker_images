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
RUN set -Eeuxo pipefail && \
    printf "Build started" && \
    ImageOS=${DISTRIB_ID}$(echo ${DISTRIB_RELEASE} | cut -d'.' -f 1) && \
    echo "IMAGE_OS=$ImageOS" | tee -a /etc/environment && \
    echo "ImageOS=$ImageOS" | tee -a /etc/environment && \
    echo "LSB_RELEASE=${DISTRIB_RELEASE}" | tee -a /etc/environment && \
    AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache && \
    echo "AGENT_TOOLSDIRECTORY=$AGENT_TOOLSDIRECTORY" | tee -a /etc/environment && \
    echo "RUN_TOOL_CACHE=$AGENT_TOOLSDIRECTORY" | tee -a /etc/environment && \
    echo "DEPLOYMENT_BASEPATH=/opt/runner" | tee -a /etc/environment && \
    echo ". /etc/environment" | tee -a /etc/profile && \
    mkdir -p $AGENT_TOOLSDIRECTORY && \
    chown 1000:1000 $AGENT_TOOLSDIRECTORY && \
    chmod 0777 $AGENT_TOOLSDIRECTORY && \
    mkdir -p /github && \
    chown 1000:1000 /github && \
    chmod 0777 /github

# > Install deps
RUN set -Eeuxo pipefail && \
    apt -yq update && \
    printf "Updated apt lists and upgraded packages\n\n" && \
    apt -yq install --no-install-recommends ssh lsb-release gawk jq curl git wget sudo gnupg-agent ca-certificates software-properties-common apt-transport-https libyaml-0-2 && \
    printf "Installed base utils"

# > Install Node.JS
RUN set -Eeuxo pipefail && \
    printf "Installing Node.JS" && \
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    DISTRO="$(lsb_release -s -c)" && \
    echo "deb https://deb.nodesource.com/node_${NODE_VERSION}.x $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src https://deb.nodesource.com/node_${NODE_VERSION}.x $DISTRO main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
    apt -yq update && \
    apt -yq install --no-install-recommends nodejs="${NODE_VERSION}*" && \
    printf "Installed Node.JS $(node -v)"

# > Clean up image
RUN set -Eeuxo pipefail && \
    printf "Cleaning image" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    printf "Cleaned up image"

# > Home repository
LABEL org.opencontainers.image.source="https://github.com/CatTheHacker/docker-images"

SHELL [ "/bin/bash", "--login" ]

# > Force bash with environment
ENTRYPOINT [ "/bin/bash", "--login" ]
