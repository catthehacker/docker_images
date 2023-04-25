#!/bin/bash -e

#set -Eeuxo pipefail

printf "\n\t🔧 Preparing apt 🔧\t\n"

# Enable retry logic for apt up to 10 times
echo 'APT::Acquire::Retries "10";' >/etc/apt/apt.conf.d/80-retries

# Configure apt to always assume Y
echo 'APT::Get::Assume-Yes "true";' >/etc/apt/apt.conf.d/90assumeyes

apt-get update
apt-get install apt-utils

# Install apt-fast using quick-install.sh
# https://github.com/ilikenwf/apt-fast
bash -c "$(curl -sL https://raw.githubusercontent.com/ilikenwf/apt-fast/master/quick-install.sh)"

# echo 'session required pam_limits.so' >>/etc/pam.d/common-session
# echo 'session required pam_limits.so' >>/etc/pam.d/common-session-noninteractive
# echo 'DefaultLimitNOFILE=65536' >>/etc/systemd/system.conf
# echo 'DefaultLimitSTACK=16M:infinity' >>/etc/systemd/system.conf

# {
#   # Raise Number of File Descriptors
#   echo '* soft nofile 65536'
#   echo '* hard nofile 65536'

#   # Double stack size from default 8192KB
#   echo '* soft stack 16384'
#   echo '* hard stack 16384'
# } >>/etc/security/limits.conf

case "$(uname -m)" in
  'aarch64')
    scripts=(
      basic
      pwsh
      go
      js
      dotnet
    )
    ;;
  'x86_64') 
    scripts=(
      basic
      pwsh
      go
      js
      rust
      vcpkg
      dotnet
    )
    ;;
  *) exit 1 ;;
esac

for SCRIPT in "${scripts[@]}"; do
  printf "\n\t🧨 Executing %s.sh 🧨\t\n" "${SCRIPT}"
  "/imagegeneration/installers/${SCRIPT}.sh"
done

printf "\n\t🐋 Cleaning image 🐋\t\n"
apt-get clean
rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/* /tmp/* || echo 'Failed to delete directories'
printf "\n\t🐋 Cleaned up image 🐋\t\n"
