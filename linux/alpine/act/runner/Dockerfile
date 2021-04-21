ARG BASEIMAGE=catthehacker/alpine
ARG TAG=act
FROM ${BASEIMAGE}:${TAG}

SHELL [ "/bin/ash", "-o", "pipefail", "-l", "-c" ]

# > Create non-root user
RUN set -Eeuxo pipefail \
    && printf "Creating non-root user\n" \
    && addgroup -S ${RUNNER_USER} -g 1000 && adduser -S ${RUNNER_USER} -u 1000 -G ${RUNNER_USER} -s /usr/bin/fish \
    && sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' \
    && sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g' \
    && sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' \
    && echo "${RUNNER_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && printf "Runner user: $(su - ${RUNNER_USER} -c id)\n" \
    && printf "Created non-root user $(grep ${RUNNER_USER} /etc/passwd)\n" \
    && echo "USER=${RUNNER_USER}" | tee -a /etc/environment \
    && echo "RUNNER_USER=${RUNNER_USER}" | tee -a /etc/environment \
    && echo "RUNNER_TEMP=/home/${RUNNER_USER}/work/_temp" | tee -a /etc/environment \
    && mkdir -p "/home/${RUNNER_USER}/work/_temp" \
    && chown -R ${RUNNER_USER}:${RUNNER_USER} "/home/${RUNNER_USER}/work" \
    && mkdir -p "/home/${RUNNER_USER}/.ssh" \
    && chmod 700 "/home/${RUNNER_USER}/.ssh" \
    && ssh-keyscan github.com | tee "/home/${RUNNER_USER}/.ssh/known_hosts" \
    && chmod 644 "/home/${RUNNER_USER}/.ssh/known_hosts" \
    && chown -R ${RUNNER_USER}:${RUNNER_USER} "/home/${RUNNER_USER}/.ssh"

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
