ARG DISTRIB_ID=ubuntu
ARG DISTRIB_RELEASE=20.04
FROM ${DISTRIB_ID}:${DISTRIB_RELEASE}

# non-root user
ARG RUNNER_USER=runner

# force apt
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies and create non-root user with sudo permissions
RUN apt -yq update && \
    apt -yq upgrade && \
    apt -yq install curl git wget sudo gnupg apt-transport-https openssl && \
    apt -yq install --no-install-recommends lsb-release gawk jq && \
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add - && \
    DISTRO="$(lsb_release -s -c)" && \
    echo "deb https://deb.nodesource.com/node_12.x $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src https://deb.nodesource.com/node_12.x $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list && \
    apt -yq update && \
    apt -yq upgrade && \
    apt -yq install nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    groupadd -g 1000 ${RUNNER_USER} && \
    useradd -u 1000 -g ${RUNNER_USER} -G sudo -m -s /bin/bash ${RUNNER_USER} && \
    sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' && \
    echo "${RUNNER_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "Customized the sudoers file for passwordless access to the ${RUNNER_USER} user!" && \
    echo "runner user:";  su - ${RUNNER_USER} -c id

# Home repository
LABEL repository="https://github.com/catthehacker/docker-images"

# Don't run as root, generally not good idea
USER runner

# Force bash with environment
ENTRYPOINT [ "/bin/bash", "--login", "-c" ]
