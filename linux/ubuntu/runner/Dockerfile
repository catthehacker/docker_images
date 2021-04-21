ARG BASEIMAGE=catthehacker/ubuntu
ARG TAG=act-latest
FROM ${BASEIMAGE}:${TAG}

# > ARGs before FROM are not accessible
ARG BASEIMAGE=catthehacker/ubuntu
ARG TAG=act-latest

# > non-root user
ARG RUNNER=runner

SHELL [ "/bin/bash", "--login", "-o", "pipefail", "-c" ]

# > Create non-root user
RUN set -Eeuxo pipefail \
    && printf "Creating non-root user\n" \
    && groupadd -g 1000 ${RUNNER} \
    && useradd -u 1000 -g ${RUNNER} -G sudo -m -s /bin/bash ${RUNNER} \
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
LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images/linux/${BASEIMAGE}/${IMAGE_TYPE}"
LABEL org.opencontainers.image.source="https://github.com/catthehacker/docker_images.git"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}
LABEL org.opencontainers.image.revision=${BUILD_REF}

USER ${RUNNER}

WORKDIR /home/runner
