#!/bin/bash
# shellcheck disable=SC2174,SC1091

set -Eeuxo pipefail

. /etc/os-release

printf "\n\t🐋 Creating runner users 🐋\t\n"

# Default admin user/group
RUNNERADMIN="${RUNNER}admin"

groupadd -g 1001 "${RUNNER}"
groupadd -g 1000 "${RUNNERADMIN}" || RUNNERADMIN="$(id -gn 1000)" # 24.04 has default user 'ubuntu' with id=1000

useradd -u 1001 -g "${RUNNER}" -G sudo -m -s /bin/bash "${RUNNER}"
useradd -u 1000 -g "${RUNNERADMIN}" -G sudo -m -s /bin/bash "${RUNNERADMIN}" || true

usermod -aG docker "${RUNNER}"
usermod -aG docker "${RUNNERADMIN}"

{
  echo "${RUNNER} ALL=(ALL) NOPASSWD: ALL"
  echo "${RUNNERADMIN} ALL=(ALL) NOPASSWD: ALL"
} | tee -a /etc/sudoers

printf "\n\t🐋 Runner user 🐋\t\n"
su - "${RUNNER}" -c id

printf "\n\t🐋 Runner admin 🐋\t\n"
su - "${RUNNERADMIN}" -c id

printf "\n\t🐋 Created non-root user 🐋\t\n"
grep "${RUNNER}" /etc/passwd

printf "\n\t🐋 Created non-root admin 🐋\t\n"
grep "${RUNNERADMIN}" /etc/passwd

sed -i /etc/environment -e "s/USER=root/USER=${RUNNER}/g"

echo "RUNNER_TEMP=/home/${RUNNER}/work/_temp" | tee -a /etc/environment
mkdir -p "/home/${RUNNER}/work/_temp"
chown -R "${RUNNER}":"${RUNNER}" "/home/${RUNNER}/work"

mkdir -m 0700 -p "/home/${RUNNER}/.ssh"

{
  ssh-keyscan -t rsa github.com
  ssh-keyscan -t rsa ssh.dev.azure.com
} | tee -a "/home/${RUNNER}/.ssh/known_hosts"

chmod 644 "/home/${RUNNER}/.ssh/known_hosts"
chown -R "${RUNNER}":"${RUNNER}" "/home/${RUNNER}/.ssh"

. /etc/environment

# Word is of the form "A"B"C" (B indicated). Did you mean "ABC" or "A\"B\"C"?shellcheck(SC2140)
# shellcheck disable=SC2140
chown -R "${RUNNER}":"${RUNNERADMIN}" "$AGENT_TOOLSDIRECTORY"

printf "\n\t🐋 Finished building 🐋\t\n"
