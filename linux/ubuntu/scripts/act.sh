#!/bin/bash
# shellcheck disable=SC2174

set -Eeuxo pipefail

printf "\n\t🐋 Build started 🐋\t\n"

# Remove '"' so it can be sourced by sh/bash
sed 's|"||g' -i "/etc/environment"

. /etc/os-release

node_arch() {
  case "$(uname -m)" in
    'aarch64') echo 'arm64' ;;
    'x86_64') echo 'x64' ;;
    'armv7l') echo 'armv7l' ;;
    *) exit 1 ;;
  esac
}

ImageOS=ubuntu$(echo "${VERSION_ID}" | cut -d'.' -f 1)
AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache
{
  echo "IMAGE_OS=$ImageOS"
  echo "ImageOS=$ImageOS"
  echo "LSB_RELEASE=${VERSION_ID}"
  echo "AGENT_TOOLSDIRECTORY=${AGENT_TOOLSDIRECTORY}"
  echo "RUN_TOOL_CACHE=${AGENT_TOOLSDIRECTORY}"
  echo "DEPLOYMENT_BASEPATH=/opt/runner"
  echo "USER=$(whoami)"
  echo "RUNNER_USER=$(whoami)"
} | tee -a "/etc/environment"

mkdir -m 0777 -p "${AGENT_TOOLSDIRECTORY}"
chown -R 1001:1000 "${AGENT_TOOLSDIRECTORY}"

mkdir -m 0777 -p /github
chown -R 1001:1000 /github

printf "\n\t🐋 Installing packages 🐋\t\n"
packages=(
  ssh
  gawk
  curl
  jq
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
apt-get -yq install --no-install-recommends --no-install-suggests "${packages[@]}"

ln -s "$(which python3)" "/usr/local/bin/python"

add-apt-repository ppa:git-core/ppa -y
apt-get update
apt-get install -y git

git --version

wget https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh -qO- | bash
apt-get update
apt-get install -y git-lfs

LSB_OS_VERSION="${VERSION_ID//\./}"
echo "LSB_OS_VERSION=${LSB_OS_VERSION}" | tee -a "/etc/environment"

wget -qO "/imagegeneration/toolset.json" "https://raw.githubusercontent.com/actions/virtual-environments/main/images/linux/toolsets/toolset-${LSB_OS_VERSION}.json" || echo "File not available"
wget -qO "/imagegeneration/LICENSE" "https://raw.githubusercontent.com/actions/virtual-environments/main/LICENSE"

if [ "$(uname -m)" = x86_64 ]; then
  wget -qO "/usr/bin/jq" "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
  chmod +x "/usr/bin/jq"
fi

printf "\n\t🐋 Updated apt lists and upgraded packages 🐋\t\n"

printf "\n\t🐋 Creating ~/.ssh and adding 'github.com' 🐋\t\n"
mkdir -m 0700 -p ~/.ssh
{
  ssh-keyscan -t rsa github.com
  ssh-keyscan -t rsa ssh.dev.azure.com
} >>/etc/ssh/ssh_known_hosts

printf "\n\t🐋 Installed base utils 🐋\t\n"

printf "\n\t🐋 Installing docker cli 🐋\t\n"
if [[ "${VERSION_ID}" == "18.04" ]]; then
  echo "deb https://packages.microsoft.com/ubuntu/${VERSION_ID}/multiarch/prod ${VERSION_CODENAME} main" | tee /etc/apt/sources.list.d/microsoft-prod.list
else
  echo "deb https://packages.microsoft.com/ubuntu/${VERSION_ID}/prod ${VERSION_CODENAME} main" | tee /etc/apt/sources.list.d/microsoft-prod.list
fi
wget -q https://packages.microsoft.com/keys/microsoft.asc
gpg --dearmor <microsoft.asc >/etc/apt/trusted.gpg.d/microsoft.gpg
apt-key add - <microsoft.asc
rm microsoft.asc
apt-get -yq update
apt-get -yq install --no-install-recommends --no-install-suggests moby-cli moby-buildx moby-compose

printf "\n\t🐋 Installed moby-cli 🐋\t\n"
docker -v

printf "\n\t🐋 Installed moby-buildx 🐋\t\n"
docker buildx version
IFS=' ' read -r -a NODE <<<"$NODE_VERSION"
for ver in "${NODE[@]}"; do
  printf "\n\t🐋 Installing Node.JS=%s 🐋\t\n" "${ver}"
  VER=$(curl https://nodejs.org/download/release/index.json | jq "[.[] | select(.version|test(\"^v${ver}\"))][0].version" -r)
  NODEPATH="$AGENT_TOOLSDIRECTORY/node/${VER:1}/$(node_arch)"
  mkdir -v -m 0777 -p "$NODEPATH"
  curl -SsL "https://nodejs.org/download/release/latest-v${ver}.x/node-$VER-linux-$(node_arch).tar.xz" -O "node-$VER-linux-$(node_arch).tar.xz"
  tar -Jxf "node-$VER-linux-$(node_arch).tar.xz" --strip-components=1 -C "$NODEPATH"
  rm "node-$VER-linux-$(node_arch).tar.xz"
  if [[ "${ver}" == "16" ]]; then
    sed "s|^PATH=|PATH=$NODEPATH/bin:|mg" -i /etc/environment
  fi
  export PATH="$NODEPATH/bin:$PATH"

  printf "\n\t🐋 Installed Node.JS 🐋\t\n"
  "${NODEPATH}"/bin/node -v

  printf "\n\t🐋 Installed NPM 🐋\t\n"
  "${NODEPATH}"/bin/npm -v
done

printf "\n\t🐋 Cleaning image 🐋\t\n"
apt-get clean
rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/* /tmp/* || echo 'Failed to delete directories'

printf "\n\t🐋 Cleaned up image 🐋\t\n"
