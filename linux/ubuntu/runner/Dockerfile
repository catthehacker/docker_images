ARG IMAGE=ghcr.io/catthehacker/ubuntu
ARG TAG=act-latest
FROM ${IMAGE}:${TAG}

ARG TARGETARCH
ARG TARGETVARIANT

# > ARGs before FROM are not accessible
ARG IMAGE=catthehacker/ubuntu
ARG TAG=act-latest

# > non-root user
ARG RUNNER=runner

SHELL [ "/bin/bash", "--noprofile", "--norc", "-e", "-o", "pipefail", "-c" ]

# > Create non-root user
RUN set -Eeuxo pipefail \
    && printf "\n\n\t🐋\t Creating non-root user \t🐋\t\n\n" \
    && groupadd -g 1000 ${RUNNER} \
    && useradd -u 1000 -g ${RUNNER} -G sudo -m -s /bin/bash ${RUNNER} \
    && echo "${RUNNER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && printf "\n\n\t🐋\t Runner user: $(su - ${RUNNER} -c id) \t🐋\t\n\n" \
    && printf "\n\n\t🐋\t Created non-root user $(grep ${RUNNER} /etc/passwd) \t🐋\t\n\n" \
    && sed -i /etc/environment -e "s/USER=root/USER=${RUNNER}/g" \
    && echo "RUNNER_TEMP=/home/${RUNNER}/work/_temp" | tee -a /etc/environment \
    && mkdir -p "/home/${RUNNER}/work/_temp" \
    && chown -R ${RUNNER}:${RUNNER} "/home/${RUNNER}/work" \
    && mkdir -p "/home/${RUNNER}/.ssh" \
    && chmod 700 "/home/${RUNNER}/.ssh" \
    && ssh-keyscan github.com | tee "/home/${RUNNER}/.ssh/known_hosts" \
    && chmod 644 "/home/${RUNNER}/.ssh/known_hosts" \
    && chown -R ${RUNNER}:${RUNNER} "/home/${RUNNER}/.ssh" \
    && printf "\n\n\t🐋\t Finished building \t🐋\t\n\n"

ARG BUILD_TAG_VERSION="dev"
ARG BUILD_TAG="runner"
ARG BUILD_REF="master"

LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images/tree/${BUILD_REF}/linux/${ImageOS}/${BUILD_TAG}/"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}-${TARGETARCH}-${TARGETVARIANT}
LABEL org.opencontainers.image.revision=${BUILD_REF}

USER ${RUNNER}

WORKDIR /home/runner
