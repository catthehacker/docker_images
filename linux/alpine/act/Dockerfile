ARG IMAGE=alpine
ARG TAG=3.13
FROM ${IMAGE}:${TAG}

# > automatic buildx ARGs
ARG TARGETARCH
ARG TARGETVARIANT

# > ARGs before FROM are not accessible
ARG IMAGE=alpine
ARG TAG=3.13
ARG IMAGEOS=alpine

SHELL [ "/bin/ash", "-l", "-o", "pipefail", "-c" ]

# > setup environment required for GitHub Actions, install dependencies/packages
RUN set -euxo pipefail \
    && printf "\n\n\t🐋\t Build started \t🐋\t\n\n" \
    && printf "\n\n\t🐋\t Adding environment variables \t🐋\t\n\n" \
    && sed 's|"||g' -i /etc/environment \
    && echo "USER=$(whoami)" | tee -a /etc/environment \
    && echo "RUNNER_USER=$(whoami)" | tee -a /etc/environment \
    && echo "IMAGE_OS=${IMAGE}" | tee -a /etc/environment \
    && echo "ImageOS=${IMAGE}" | tee -a /etc/environment \
    #&& echo "LSB_RELEASE=${DISTRIB_RELEASE}" | tee -a /etc/environment \
    && AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache \
    && echo "AGENT_TOOLSDIRECTORY=${AGENT_TOOLSDIRECTORY}" | tee -a /etc/environment \
    && echo "RUN_TOOL_CACHE=${AGENT_TOOLSDIRECTORY}" | tee -a /etc/environment \
    && echo "DEPLOYMENT_BASEPATH=/opt/runner" | tee -a /etc/environment \
    && echo ". /etc/environment" | tee -a /etc/profile \
    && printf "\n\n\t🐋\t Creating tool cache directory and '/github' \t🐋\t\n\n" \
    && mkdir -p ${AGENT_TOOLSDIRECTORY} \
    && chown 1000:1000 ${AGENT_TOOLSDIRECTORY} \
    && chmod 0777 ${AGENT_TOOLSDIRECTORY} \
    && mkdir -p /github \
    && chown 1000:1000 /github \
    && chmod 0777 /github \
    && printf "\n\n\t🐋\t Installing packages \t🐋\t\n\n" \
    && apk --no-cache add bash openssh-client gawk jq curl git wget sudo gnupg ca-certificates yaml zstd zip unzip xz icu build-base python3 nodejs docker-cli \
    && ln -s $(which python3) /usr/local/bin/python \
    && printf "\n\n\t🐋\t Docker: $(docker -v) \t🐋\t\n\n" \
    && printf "\n\n\t🐋\t Node: $(node -v) \t🐋\t\n\n" \
    && apk list -I | sort \
    && printf "\n\n\t🐋\t Creating ~/.ssh and adding 'github.com' \t🐋\t\n\n" \
    && mkdir -p ~/.ssh \
    && chmod 700 ~/.ssh \
    && ssh-keyscan github.com | tee ~/.ssh/known_hosts \
    && printf "\n\n\t🐋\t Installed base utils \t🐋\t\n\n" \
    && sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' \
    && sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g' \
    && sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' \
    && printf "\n\n\t🐋\t Cleaning image \t🐋\t\n\n" \
    && apk clean cache \
    && rm -rf /var/cache/* /var/log/* /tmp/* || echo 'Failed to delete directories' \
    && printf "\n\n\t🐋\t Cleaned up image \t🐋\t\n\n"

ARG BUILD_TAG_VERSION="dev"
ARG BUILD_TAG="act"
ARG BUILD_REF="master"

LABEL org.opencontainers.image.vendor="catthehacker"
LABEL org.opencontainers.image.authors="me@hackerc.at"
LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images/tree/${BUILD_REF}/linux/${IMAGEOS}/${BUILD_TAG}/"
LABEL org.opencontainers.image.source="https://github.com/catthehacker/docker_images"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}-${TARGETARCH}-${TARGETVARIANT}
LABEL org.opencontainers.image.revision=${BUILD_REF}

USER root
