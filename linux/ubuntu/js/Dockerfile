ARG IMAGE=ghcr.io/catthehacker/ubuntu
ARG TAG=act-latest
FROM ${IMAGE}:${TAG}

ARG TARGETARCH
ARG TARGETVARIANT

SHELL [ "/bin/bash", "--noprofile", "--norc", "-e", "-o", "pipefail", "-c" ]
RUN set -Eeuxo pipefail \
    && printf "\n\n\t🐋\t Installing JS tools \t🐋\t\n\n" \
    && printf "\n\n\t🐋\t Installed NPM $(npm -v) \t🐋\t\n\n" \
    && npm install -g npm \
    && npm install -g pnpm \
    && npm install -g yarn \
    && printf "\n\n\t🐋\t Installed NPM $(npm -v) \t🐋\t\n\n" \
    && printf "\n\n\t🐋\t Installed PNPM $(pnpm -v) \t🐋\t\n\n" \
    && printf "\n\n\t🐋\t Installed YARN $(yarn -v) \t🐋\t\n\n" \
    && npm install -g grunt gulp n parcel-bundler typescript newman vercel webpack webpack-cli lerna \
    && npm install -g --unsafe-perm netlify-cli \
    && printf "\n\n\t🐋\t Cleaning image \t🐋\t\n\n" \
    && apt-get clean \
    && rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/* /tmp/* || echo 'Failed to delete directories' \
    && printf "\n\n\t🐋\t Cleaned up image \t🐋\t\n\n"

ARG BUILD_TAG_VERSION="dev"
ARG BUILD_TAG="rust"
ARG BUILD_REF="master"

LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images/tree/${BUILD_REF}/linux/${ImageOS}/${BUILD_TAG}/"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}-${TARGETARCH}-${TARGETVARIANT}
LABEL org.opencontainers.image.revision=${BUILD_REF}
