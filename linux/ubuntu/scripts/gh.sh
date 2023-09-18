#!/bin/bash -e
################################################################################
##  File:  github-cli.sh
##  Desc:  Installs GitHub CLI
##         Must be run as non-root user after homebrew
################################################################################
# source: https://github.com/actions/virtual-environments/blob/be27ebfdb31aece2c90fbe1984c1749cbd1b464c/images/linux/scripts/installers/github-cli.sh

# Install GitHub CLI
ARCH=$(uname -m)
if [ "$ARCH" = x86_64 ]; then ARCH=amd64; fi
if [ "$ARCH" = aarch64 ]; then ARCH=arm64; fi
if [ "$ARCH" = armv7l ]; then ARCH=armv6; fi

url=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | jq -r ".assets[].browser_download_url|select(contains(\"linux\") and contains(\"$ARCH\") and contains(\".deb\"))")
wget -q "$url" -O "/tmp/gh.deb"
apt install /tmp/gh.deb
