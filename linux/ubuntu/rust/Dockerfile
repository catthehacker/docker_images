ARG FROM_IMAGE=ghcr.io/catthehacker/ubuntu
ARG FROM_TAG=act-latest
FROM ${FROM_IMAGE}:${FROM_TAG}

ARG TARGETARCH
ARG TARGETVARIANT

ARG DISTRO=ubuntu

ARG RUSTUP_HOME=/usr/share/rust/.rustup
ARG CARGO_HOME=/usr/share/rust/.cargo

SHELL [ "/bin/bash", "--noprofile", "--norc", "-e", "-o", "pipefail", "-c" ]

RUN set -Eeuxo pipefail \
    && printf "\n\n\t🐋 Installing dependencies 🐋\t\n\n" \
    && apt-get -yq update \
    && apt-get -yq install build-essential llvm \
    && printf "\n\n\t🐋 Installing Rust 🐋\t\n\n" \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=stable --profile=minimal \
    && source ${CARGO_HOME}/env \
    && rustup component add rustfmt clippy \
    && cargo install --locked bindgen cbindgen cargo-audit cargo-outdated \
    && chmod -R 777 $(dirname ${RUSTUP_HOME}) \
    && rm -rf ${CARGO_HOME}/registry/* \
    && sed "s|PATH=|PATH=${CARGO_HOME}/bin:|g" -i /etc/environment \
    && cd /root \
    && ln -sf ${CARGO_HOME} .cargo \
    && ln -sf ${RUSTUP_HOME} .rustup \
    && echo "RUSTUP_HOME=${RUSTUP_HOME}" | tee -a /etc/environment \
    && echo "CARGO_HOME=${CARGO_HOME}" | tee -a /etc/environment \
    && printf "\n\n\t🐋 Installed RUSTUP $(rustup -V) 🐋\t\n\n" \
    && printf "\n\n\t🐋 Installed CARGO $(cargo -V) 🐋\t\n\n" \
    && printf "\n\n\t🐋 Installed RUSTC $(rustc -V) 🐋\t\n\n" \
    && printf "\n\n\t🐋 Cleaning image 🐋\t\n\n" \
    && apt-get clean \
    && rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/* /tmp/* || echo 'Failed to delete directories' \
    && printf "\n\n\t🐋 Cleaned up image 🐋\t\n\n"

ARG BUILD_TAG_VERSION="dev"
ARG BUILD_TAG="rust"
ARG BUILD_REF="master"

LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images/tree/${BUILD_REF}/linux/${DISTRO}/${BUILD_TAG}/"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}-${TARGETARCH}
LABEL org.opencontainers.image.revision=${BUILD_REF}
