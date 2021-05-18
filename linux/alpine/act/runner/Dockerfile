ARG BASEIMAGE=catthehacker/alpine
ARG TAG=act
FROM ${BASEIMAGE}:${TAG}

SHELL [ "/bin/ash", "-o", "pipefail", "-l", "-c" ]

ARG RUNNER=runner

# > Create non-root user
RUN set -euxo pipefail \
    && printf "Creating non-root user\n" \
    && addgroup -S ${RUNNER} -g 1000 && adduser -S ${RUNNER} -u 1000 -G ${RUNNER} -s /usr/bin/fish \
    && sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' \
    && sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g' \
    && sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' \
    && echo "${RUNNER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && printf "Runner user: $(su - ${RUNNER} -c id)\n" \
    && printf "Created non-root user $(grep ${RUNNER} /etc/passwd)\n" \
    && sed -i /etc/environment -e "s/USER=root/USER=${RUNNER}/g" \
    && echo "RUNNER_TEMP=/home/${RUNNER}/work/_temp" | tee -a /etc/environment \
    && mkdir -p "/home/${RUNNER}/work/_temp" \
    && chown -R ${RUNNER}:${RUNNER} "/home/${RUNNER}/work" \
    && mkdir -p "/home/${RUNNER}/.ssh" \
    && chmod 700 "/home/${RUNNER}/.ssh" \
    && ssh-keyscan github.com | tee "/home/${RUNNER}/.ssh/known_hosts" \
    && chmod 644 "/home/${RUNNER}/.ssh/known_hosts" \
    && chown -R ${RUNNER}:${RUNNER} "/home/${RUNNER}/.ssh"

ARG BUILD_TAG_VERSION="master"
ARG BUILD_TAG="runner"
ARG BUILD_REF="master"

LABEL org.opencontainers.image.vendor="catthehacker"
LABEL org.opencontainers.image.authors="me@hackerc.at"
LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images/tree/${BUILD_REF}/linux/${ImageOS}/${BUILD_TAG}/"
LABEL org.opencontainers.image.source="https://github.com/catthehacker/docker_images.git"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}-${TARGETARCH}-${TARGETVARIANT}
LABEL org.opencontainers.image.revision=${BUILD_REF}
