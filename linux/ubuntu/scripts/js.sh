#!/bin/bash

set -Eeuo pipefail

# source environment because Linux is beautiful and not really confusing like Windows
# also you are apparently not supposed to source that file because it's not conforming to standard shell envvar
# format but we already fix that in base image
# yes, this is sarcasm
# shellcheck disable=SC1091
. /etc/environment

printf "\n\t🐋 Installed NPM 🐋\t\n"
npm -v

versions=("10" "12")
JSON=$(wget -qO- https://nodejs.org/download/release/index.json | jq --compact-output)

for V in "${versions[@]}"; do
  printf "\n\t🐋 Installing NODE=%s 🐋\t\n" "${V}"
  VER=$(echo "${JSON}" | jq "[.[] | select(.version|test(\"^v${V}\"))][0].version" -r)
  NODEPATH="$AGENT_TOOLSDIRECTORY/node/${VER:1}/x64"

  # disable warning about 'mkdir -m -p'
  # shellcheck disable=SC2174
  mkdir -v -m 0777 -p "$NODEPATH"
  ARCH=$(uname -m)
  if [ "$ARCH" = x86_64 ]; then ARCH=x64; fi
  if [ "$ARCH" = aarch64 ]; then ARCH=arm64; fi
  wget -qO- "https://nodejs.org/download/release/latest-v${V}.x/node-$VER-linux-$ARCH.tar.xz" | tar -Jxf - --strip-components=1 -C "$NODEPATH"

  ENVVAR="${V//\./_}"
  echo "${ENVVAR}=${NODEPATH}" >>/etc/environment

  printf "\n\t🐋 Installed NODE 🐋\t\n"
  "$NODEPATH/bin/node" -v
done

printf "\n\t🐋 Installing JS tools 🐋\t\n"
npm install -g npm
npm install -g pnpm
npm install -g yarn
npm install -g grunt gulp n parcel-bundler typescript newman vercel webpack webpack-cli lerna
npm install -g --unsafe-perm netlify-cli

printf "\n\t🐋 Installed NPM 🐋\t\n"
npm -v

printf "\n\t🐋 Installed PNPM 🐋\t\n"
pnpm -v

printf "\n\t🐋 Installed YARN 🐋\t\n"
yarn -v

printf "\n\t🐋 Installing NVM tools 🐋\t\n"
VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r '.tag_name')
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$VERSION/install.sh" | bash
export NVM_DIR=$HOME/.nvm
echo "NVM_DIR=$HOME/.nvm" | tee -a /etc/environment

# Expressions don't expand in single quotes, use double quotes for that.shellcheck(SC2016)
# shellcheck disable=SC2016
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' | tee -a /etc/skel/.bash_profile

# Not following: ./nvm.sh was not specified as input (see shellcheck -x).shellcheck(SC1091)
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

printf "\n\t🐋 Installed NVM 🐋\t\n"
nvm --version

printf "\n\t🐋 Cleaning image 🐋\t\n"
apt-get clean
rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/* /tmp/* || echo 'Failed to delete directories'
printf "\n\t🐋 Cleaned up image 🐋\t\n"
