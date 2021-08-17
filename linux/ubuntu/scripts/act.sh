#!/bin/bash

# disable warning about 'mkdir -m -p'
# shellcheck disable=SC2174

set -Eeuxo pipefail

printf "\n\t🐋 Build started 🐋\t\n"

sed 's|"||g' -i "/etc/environment"

echo "USER=$(whoami)" | tee -a "/etc/environment"
echo "RUNNER_USER=$(whoami)" | tee -a "/etc/environment"

ImageOS=ubuntu$(echo "${FROM_TAG}" | cut -d'.' -f 1)
echo "IMAGE_OS=$ImageOS" | tee -a "/etc/environment"
echo "ImageOS=$ImageOS" | tee -a "/etc/environment"
echo "LSB_RELEASE=${FROM_TAG}" | tee -a "/etc/environment"

AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache
echo "AGENT_TOOLSDIRECTORY=${AGENT_TOOLSDIRECTORY}" | tee -a "/etc/environment"
echo "RUN_TOOL_CACHE=${AGENT_TOOLSDIRECTORY}" | tee -a "/etc/environment"
echo "DEPLOYMENT_BASEPATH=/opt/runner" | tee -a "/etc/environment"
echo ". /etc/environment" | tee -a /etc/profile

mkdir -m 0777 -p "${AGENT_TOOLSDIRECTORY}"
chown -R 1001:1000 "${AGENT_TOOLSDIRECTORY}"

mkdir -m 0777 -p /github
chown -R 1001:1000 /github

printf "\n\t🐋 Installing packages 🐋\t\n"
packages=(
  ssh
  lsb-release
  gawk
  curl
  git
  wget
  sudo
  gnupg-agent
  ca-certificates
  software-properties-common
  apt-transport-https
  libyaml-0-2
  zstd
  zip
  unzip
  xz-utils
)

apt-get -yq update
apt-get -yq install --no-install-recommends "${packages[@]}"

ln -s "$(which python3)" "/usr/local/bin/python"

LSB_OS_VERSION=$(lsb_release -rs | sed 's|\.||g')
echo "LSB_OS_VERSION=${LSB_OS_VERSION}" | tee -a "/etc/environment"

wget -qO "/imagegeneration/toolset.json" "https://raw.githubusercontent.com/actions/virtual-environments/main/images/linux/toolsets/toolset-${LSB_OS_VERSION}.json"

wget -qO "/usr/bin/jq" "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
chmod +x "/usr/bin/jq"

if [[ "${FROM_TAG}" == "16.04" ]]; then
  printf 'git-lfs not available for Xenial'
else
  apt-get -yq install --no-install-recommends git-lfs
fi

printf "\n\t🐋 Updated apt lists and upgraded packages 🐋\t\n"

printf "\n\t🐋 Creating ~/.ssh and adding 'github.com' 🐋\t\n"
mkdir -m 0700 -p ~/.ssh
ssh-keyscan -t rsa github.com >>/etc/ssh/ssh_known_hosts
ssh-keyscan -t rsa ssh.dev.azure.com >>/etc/ssh/ssh_known_hosts

printf "\n\t🐋 Installed base utils 🐋\t\n"

printf "\n\t🐋 Installing docker cli 🐋\t\n"
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
apt-add-repository "https://packages.microsoft.com/ubuntu/${FROM_TAG}/prod"
apt-get -yq update
apt-get -yq install --no-install-recommends moby-cli moby-buildx

printf "\n\t🐋 Installed moby-cli 🐋\t\n"
docker -v

printf "\n\t🐋 Installed moby-buildx 🐋\t\n"
docker buildx version

printf "\n\t🐋 Installing Node.JS 🐋\t\n"
ARCH=$(uname -m)
if [ "$ARCH" = x86_64 ]; then ARCH=x64; fi
if [ "$ARCH" = aarch64 ]; then ARCH=arm64; fi
VER=$(curl https://nodejs.org/download/release/index.json | jq "[.[] | select(.version|test(\"^v${NODE_VERSION}\"))][0].version" -r)
NODEPATH="$AGENT_TOOLSDIRECTORY/node/${VER:1}/$ARCH"
mkdir -v -m 0777 -p "$NODEPATH"
curl -SsL "https://nodejs.org/download/release/latest-v${NODE_VERSION}.x/node-$VER-linux-$ARCH.tar.xz" | tar -Jxf - --strip-components=1 -C "$NODEPATH"
sed "s|^PATH=|PATH=$NODEPATH/bin:|mg" -i /etc/environment
export PATH="$NODEPATH/bin:$PATH"

printf "\n\t🐋 Installed Node.JS 🐋\t\n"
node -v

printf "\n\t🐋 Installed NPM 🐋\t\n"
npm -v

printf "\n\t🐋 Cleaning image 🐋\t\n"
apt-get clean
rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/* /tmp/* || echo 'Failed to delete directories'

printf "\n\t🐋 Cleaned up image 🐋\t\n"
