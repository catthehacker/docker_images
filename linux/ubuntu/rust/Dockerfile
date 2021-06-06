ARG IMAGE=ghcr.io/catthehacker/ubuntu
ARG TAG=act-latest
FROM ${IMAGE}:${TAG}

ARG TARGETARCH
ARG TARGETVARIANT

ARG RUSTUP_HOME=/usr/share/rust/.rustup
ARG CARGO_HOME=/usr/share/rust/.cargo

SHELL [ "/bin/bash", "--noprofile", "--norc", "-e", "-o", "pipefail", "-c" ]
RUN set -Eeuxo pipefail \
    && printf "Installing dependencies\n" \
    && apt-get -yq update \
    && apt-get -yq install build-essential llvm \
    && printf "Installing Rust\n" \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=stable --profile=minimal \
    && source ${CARGO_HOME}/env \
    && rustup component add rustfmt clippy \
    && cargo install --locked bindgen cbindgen cargo-audit cargo-outdated \
    && chmod -R 777 $(dirname ${RUSTUP_HOME}) \
    && rm -rf ${CARGO_HOME}/registry/* \
    && sed "s|PATH=\"|PATH=\"${CARGO_HOME}/bin:|g" -i /etc/environment \
    && sed 's|"||g' -i /etc/environment \
    && cd /root \
    && ln -sf ${CARGO_HOME} .cargo \
    && ln -sf ${RUSTUP_HOME} .rustup \
    && echo "RUSTUP_HOME=${RUSTUP_HOME}" | tee -a /etc/environment \
    && echo "CARGO_HOME=${CARGO_HOME}" | tee -a /etc/environment

ARG BUILD_TAG_VERSION="dev"
ARG BUILD_TAG="rust"
ARG BUILD_REF="master"

LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images/tree/${BUILD_REF}/linux/${ImageOS}/${BUILD_TAG}/"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}-${TARGETARCH}-${TARGETVARIANT}
LABEL org.opencontainers.image.revision=${BUILD_REF}
