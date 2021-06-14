ARG FROM_IMAGE=ghcr.io/catthehacker/ubuntu
ARG FROM_TAG=act-latest
FROM ${FROM_IMAGE}:${FROM_TAG}

ARG TARGETARCH
ARG TARGETVARIANT

# > ARGs before FROM are not accessible
ARG FROM_IMAGE=catthehacker/ubuntu
ARG FROM_TAG=act-latest

# > non-root user
ARG RUNNER=runner

SHELL [ "/bin/bash", "--noprofile", "--norc", "-e", "-o", "pipefail", "-c" ]

# > Create non-root user
RUN set -Eeuxo pipefail \
    && printf "\n\n\t🐋 Creating runner users 🐋\t\n\n" \
    && groupadd -g 1001 ${RUNNER} \
    && groupadd -g 1000 ${RUNNER}admin \
    && useradd -u 1001 -g ${RUNNER} -G sudo -m -s /bin/bash ${RUNNER} \
    && useradd -u 1000 -g ${RUNNER}admin -G sudo -m -s /bin/bash ${RUNNER}admin \
    && echo "${RUNNER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && echo "${RUNNER}admin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && printf "\n\n\t🐋 Runner user: $(su - ${RUNNER} -c id) 🐋\t\n\n" \
    && printf "\n\n\t🐋 Runner admin: $(su - ${RUNNER}admin -c id) 🐋\t\n\n" \
    && printf "\n\n\t🐋 Created non-root user $(grep ${RUNNER} /etc/passwd) 🐋\t\n\n" \
    && printf "\n\n\t🐋 Created non-root admin $(grep ${RUNNER}admin /etc/passwd) 🐋\t\n\n" \
    && sed -i /etc/environment -e "s/USER=root/USER=${RUNNER}/g" \
    && echo "RUNNER_TEMP=/home/${RUNNER}/work/_temp" | tee -a /etc/environment \
    && mkdir -p "/home/${RUNNER}/work/_temp" \
    && chown -R ${RUNNER}:${RUNNER} "/home/${RUNNER}/work" \
    && mkdir -m 0700 -p "/home/${RUNNER}/.ssh" \
    && ssh-keyscan github.com | tee "/home/${RUNNER}/.ssh/known_hosts" \
    && chmod 644 "/home/${RUNNER}/.ssh/known_hosts" \
    && chown -R ${RUNNER}:${RUNNER} "/home/${RUNNER}/.ssh" \
    && . /etc/environment \
    && chown -R ${RUNNER}:${RUNNER}admin $AGENT_TOOLSDIRECTORY \
    && printf "\n\n\t🐋 Finished building 🐋\t\n\n"

ARG BUILD_TAG_VERSION="dev"
ARG BUILD_TAG="runner"
ARG BUILD_REF="master"

LABEL org.opencontainers.image.url="https://github.com/catthehacker/docker_images/tree/${BUILD_REF}/linux/${ImageOS}/${BUILD_TAG}/"
LABEL org.opencontainers.image.version=${BUILD_TAG_VERSION}
LABEL org.opencontainers.image.title=${BUILD_TAG}-${TARGETARCH}
LABEL org.opencontainers.image.revision=${BUILD_REF}

USER ${RUNNER}

WORKDIR /home/runner
