ARG FROM_IMAGE=buildpack-deps
ARG FROM_TAG=20.04
FROM ${FROM_IMAGE}:${FROM_TAG}

# > automatic buildx ARGs
ARG TARGETARCH

# > ARGs before FROM are not accessible
ARG FROM_IMAGE=buildpack-deps
ARG FROM_TAG=20.04

# > NodeJS version
ARG NODE_VERSION=12

# > Distro
ARG DISTRO=ubuntu
ARG TYPE=act

# > Force apt to not be interactive/not ask
ARG DEBIAN_FRONTEND=noninteractive

SHELL [ "/bin/bash", "--noprofile", "--norc", "-e", "-o", "pipefail", "-c" ]

# > setup environment required for GitHub Actions
RUN set -Eeuxo pipefail \
    && printf "\n\n\t🐋 Build started 🐋\t\n\n" \
    && sed 's|"||g' -i /etc/environment \
    && echo "USER=$(whoami)" | tee -a /etc/environment \
    && echo "RUNNER_USER=$(whoami)" | tee -a /etc/environment \
    && ImageOS=ubuntu$(echo ${FROM_TAG} | cut -d'.' -f 1) \
    && echo "IMAGE_OS=$ImageOS" | tee -a /etc/environment \
    && echo "ImageOS=$ImageOS" | tee -a /etc/environment \
    && echo "LSB_RELEASE=${FROM_TAG}" | tee -a /etc/environment \
    && AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache \
    && echo "AGENT_TOOLSDIRECTORY=$AGENT_TOOLSDIRECTORY" | tee -a /etc/environment \
    && echo "RUN_TOOL_CACHE=$AGENT_TOOLSDIRECTORY" | tee -a /etc/environment \
    && echo "DEPLOYMENT_BASEPATH=/opt/runner" | tee -a /etc/environment \
    && echo ". /etc/environment" | tee -a /etc/profile \
    && mkdir -m 0777 -p $AGENT_TOOLSDIRECTORY \
    && chown -R 1001:1000 $AGENT_TOOLSDIRECTORY \
    && mkdir -m 0777 -p /github \
    && chown -R 1001:1000 /github \
    && printf "\n\n\t🐋 Installing packages 🐋\t\n\n" \
    && apt-get -yq update \
    && apt-get -yq install --no-install-recommends ssh lsb-release gawk jq curl git wget sudo gnupg-agent ca-certificates software-properties-common apt-transport-https libyaml-0-2 zstd unzip xz-utils \
    && ln -s $(which python3) /usr/local/bin/python \
    && [[ "${FROM_TAG}" == "16.04" ]] && printf 'git-lfs not available for Xenial' || apt-get -yq install --no-install-recommends git-lfs \
    && printf "\n\n\t🐋 Updated apt lists and upgraded packages 🐋\t\n\n" \
    && printf "\n\n\t🐋 Creating ~/.ssh and adding 'github.com' 🐋\t\n\n" \
    && mkdir -m 0700 -p ~/.ssh \
    && ssh-keyscan github.com | tee ~/.ssh/known_hosts \
    && printf "\n\n\t🐋 Installed base utils 🐋\t\n\n" \
    && printf "\n\n\t🐋 Installing docker cli 🐋\t\n\n" \
    && curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - \
    && sudo apt-add-repository https://packages.microsoft.com/ubuntu/${FROM_TAG}/prod \
    && apt-get -yq update \
    && apt-get -yq install --no-install-recommends moby-cli moby-buildx \
    && printf "\n\n\t🐋 Installed moby-cli 🐋\t\n\n" \
    && docker version \
    && printf "\n\n\t🐋 Installed moby-buildx 🐋\t\n\n" \
    && docker buildx version \
    && printf "\n\n\t🐋 Installing Node.JS 🐋\t\n\n" \
    && VER=$(curl https://nodejs.org/download/release/index.json | jq "[.[] | select(.version|test(\"^v${NODE_VERSION}\"))][0].version" -r) \
    && NODEPATH="$AGENT_TOOLSDIRECTORY/node/${VER:1}/x64" \
    && mkdir -v -m 0777 -p $NODEPATH \
    && curl "https://nodejs.org/download/release/latest-v${NODE_VERSION}.x/node-$VER-linux-x64.tar.xz" | tar -Jxf - --strip-components=1 -C $NODEPATH \
    && sed "s|^PATH=|PATH=$NODEPATH/bin:|mg" -i /etc/environment \
    && export PATH="$NODEPATH/bin:$PATH" \
    && printf "\n\n\t🐋 Installed Node.JS $(node -v) 🐋\t\n\n" \
    && printf "\n\n\t🐋 Installed NPM $(npm -v) 🐋\t\n\n" \
    && printf "\n\n\t🐋 Cleaning image 🐋\t\n\n" \
    && apt-get clean \
    && rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/* /tmp/* || echo 'Failed to delete directories' \
    && printf "\n\n\t🐋 Cleaned up image 🐋\t\n\n"

ARG BUILD_TAG_VERSION="dev"
ARG BUILD_TAG="act"
ARG BUILD_REF="master"

LABEL org.opencontainers.image.vendor="catthehacker"
LABEL org.opencontainers.image.authors="me@hackerc.at"
LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images/tree/${BUILD_REF}/linux/${DISTRO}/${TYPE}/"
LABEL org.opencontainers.image.source="https://github.com/catthehacker/docker_images"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}-${TARGETARCH}
LABEL org.opencontainers.image.revision=${BUILD_REF}

USER root
