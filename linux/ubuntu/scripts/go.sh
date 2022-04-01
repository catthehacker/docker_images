#!/bin/bash
# shellcheck disable=SC1091,SC2174

. /etc/environment

set -Eeuxo pipefail

printf "\n\t🐋 Installing Go(lang) 🐋\t\n"

wget -qO- "$(jq -r '.toolcache[] | select(.name == "go") | .url' "/imagegeneration/toolset.json")" > "/tmp/go-toolset.json"

go_arch() {
  case "$(uname -m)" in
    'x86_64') echo 'amd64' ;;
    'aarch64') echo 'arm64' ;;
  esac
}

for V in $(jq -r '.toolcache[] | select(.name == "go") | .versions[]' "/imagegeneration/toolset.json"); do
  printf "\n\t🐋 Installing GO=%s 🐋\t\n" "${V}"
  VER=$(jq -r "[.[] | select(.version|test(\"^${V}\"))][0].version" "/tmp/go-toolset.json")
  GOPATH="$AGENT_TOOLSDIRECTORY/go/${VER}/x64"

  mkdir -v -m 0777 -p "$GOPATH"
  DL_VER="${VER}"
  # hack
  # TODO: i hate shell scripts, please can I have powershell on linux and no, python is not a solution, it should die
  # TODO: write own thing to get links from go.dev and versions from actions/go-versions, mash it together, ?????, works
  if [[ "$(echo ${VER} | cut -d. -f3)" == "0" ]]; then
    DL_VER=$(echo "${VER}" | cut -d. -f-2)
  fi
  wget -qO- "https://golang.org/dl/go${DL_VER}.linux-$(go_arch).tar.gz" | tar -zxf - --strip-components=1 -C "$GOPATH"

  # ENVVAR="${V//\./_}"
  # echo "${ENVVAR}=${GOPATH}" >>/etc/environment

  printf "\n\t🐋 Installed GO 🐋\t\n"
  "$GOPATH/bin/go" version

  if [[ "${V}" == "1.15.*" ]]; then
    ln -s "$GOPATH/bin/*" /usr/bin/
  fi
done

printf "\n\t🐋 Cleaning image 🐋\t\n"
apt-get clean
rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/* /tmp/* || echo 'Failed to delete directories'
printf "\n\t🐋 Cleaned up image 🐋\t\n"
