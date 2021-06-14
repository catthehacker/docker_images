ARG FROM_IMAGE=ghcr.io/catthehacker/ubuntu
ARG FROM_TAG=act-latest
FROM ${FROM_IMAGE}:${FROM_TAG}

ARG TARGETARCH
ARG TARGETVARIANT

SHELL [ "/bin/bash", "--noprofile", "--norc", "-e", "-o", "pipefail", "-c" ]

RUN set -Eeuxo pipefail \
    && printf "\n\n\t🐋 Installing JS tools 🐋\t\n\n" \
    && printf "\n\n\t🐋 Installed NPM $(npm -v) 🐋\t\n\n" \
    && npm install -g npm \
    && npm install -g pnpm \
    && npm install -g yarn \
    && printf "\n\n\t🐋 Installed NPM $(npm -v) 🐋\t\n\n" \
    && printf "\n\n\t🐋 Installed PNPM $(pnpm -v) 🐋\t\n\n" \
    && printf "\n\n\t🐋 Installed YARN $(yarn -v) 🐋\t\n\n" \
    && npm install -g grunt gulp n parcel-bundler typescript newman vercel webpack webpack-cli lerna \
    && npm install -g --unsafe-perm netlify-cli \
    && printf "\n\n\t🐋 Installing NVM tools 🐋\t\n\n" \
    && VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r '.tag_name') \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$VERSION/install.sh | bash \
    && export NVM_DIR=$HOME/.nvm \
    && echo 'NVM_DIR=$HOME/.nvm' | tee -a /etc/environment \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' | tee -a /etc/skel/.bash_profile \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && printf "\n\n\t🐋 Installed NVM $(nvm --version) 🐋\t\n\n" \
    && printf "\n\n\t🐋 Cleaning image 🐋\t\n\n" \
    && apt-get clean \
    && rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/* /tmp/* || echo 'Failed to delete directories' \
    && printf "\n\n\t🐋 Cleaned up image 🐋\t\n\n"

ARG BUILD_TAG_VERSION="dev"
ARG BUILD_TAG="js"
ARG BUILD_REF="master"

LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images/tree/${BUILD_REF}/linux/${ImageOS}/${BUILD_TAG}/"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}-${TARGETARCH}
LABEL org.opencontainers.image.revision=${BUILD_REF}
