#!/bin/bash

# disable warning about 'mkdir -m -p'
# shellcheck disable=SC2174

# source environment because Linux is beautiful and not really confusing like Windows, also you are apparently not supposed to source that file because it's not conforming to standard shell format but we already fix that in base image
# yes, this is sarcasm
# shellcheck disable=SC1091
. /etc/environment

# no -x because big json
set -Eeuo pipefail

printf "\n\t🐋 Installing Go(lang) 🐋\t\n"

JSON=$(wget -qO- "$(jq -r '.toolcache[] | select(.name == "go") | .url' "/imagegeneration/toolset.json")" | jq --compact-output)

for V in $(jq -r '.toolcache[] | select(.name == "go") | .versions[]' "/imagegeneration/toolset.json"); do
  printf "\n\t🐋 Installing GO=%s 🐋\t\n" "${V}"
  VER=$(echo "${JSON}" | jq "[.[] | select(.version|test(\"^${V}\"))][0].version" -r)
  GOPATH="$AGENT_TOOLSDIRECTORY/go/${VER}/x64"

  mkdir -v -m 0777 -p "$GOPATH"
  wget -qO- "https://golang.org/dl/go${VER}.linux-amd64.tar.gz" | tar -zxf - --strip-components=1 -C "$GOPATH"

  ENVVAR="${V//\./_}"
  echo "${ENVVAR}=${GOPATH}" >>/etc/environment

  printf "\n\t🐋 Installed GO 🐋\t\n"
  "$GOPATH/bin/go" version

  if [[ "${V}" == "1.15" ]]; then
    ln -s "$GOPATH/bin/*" /usr/bin/
  fi
done

printf "\n\t🐋 Cleaning image 🐋\t\n"
apt-get clean
rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/* /tmp/* || echo 'Failed to delete directories'
printf "\n\t🐋 Cleaned up image 🐋\t\n"
