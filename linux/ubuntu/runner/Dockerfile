ARG DISTRIB_ID=ubuntu
ARG DISTRIB_RELEASE=20.04
FROM ${DISTRIB_ID}:${DISTRIB_RELEASE}

# > ARGs before FROM are not accessible
ARG DISTRIB_ID=ubuntu
ARG DISTRIB_RELEASE=20.04

# > non-root user
ARG RUNNER_USER=runner

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
    echo "RUNNER_USER=${RUNNER_USER}" | tee -a /etc/environment && \
    echo "RUNNER_TEMP=/home/${RUNNER_USER}/work/_temp" | tee -a /etc/environment && \
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
    apt -yq install --no-install-recommends ssh lsb-release gawk jq curl git wget sudo gnupg-agent ca-certificates software-properties-common apt-transport-https libyaml-0-2 zstd unzip && \
    printf "Installed base utils\n" && \
    printf "Cleaning image\n" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    printf "Cleaned up image\n"

# > Install Node.JS
RUN set -Eeuxo pipefail && \
    printf "Installing Node.JS\n" && \
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    DISTRO="$(lsb_release -s -c)" && \
    echo "deb https://deb.nodesource.com/node_${NODE_VERSION}.x $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src https://deb.nodesource.com/node_${NODE_VERSION}.x $DISTRO main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
    apt -yq update && \
    apt -yq install --no-install-recommends nodejs="${NODE_VERSION}*" && \
    printf "Installed Node.JS $(node -v)\n" && \
    dpkg-query -f '${binary:Package}\n' -W && \
    printf "Cleaning image\n" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    printf "Cleaned up image\n"

# > Create non-root user
RUN set -Eeuxo pipefail && \
    printf "Creating non-root user\n" && \
    groupadd -g 1000 ${RUNNER_USER} && \
    useradd -u 1000 -g ${RUNNER_USER} -G sudo -m -s /bin/bash ${RUNNER_USER} && \
    sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' && \
    echo "${RUNNER_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    printf "runner user: $(su - ${RUNNER_USER} -c id)\n" && \
    printf "Created non-root user $(grep ${RUNNER_USER} /etc/passwd)\n"

# > Home repository
LABEL org.opencontainers.image.source="https://github.com/CatTheHacker/docker-images"

# > Don't run as root, generally not good idea
USER ${RUNNER_USER}:${RUNNER_USER}

SHELL [ "/bin/bash", "--login" ]

WORKDIR /home/runner

# > Force bash with environment
ENTRYPOINT [ "/bin/bash", "--login" ]
