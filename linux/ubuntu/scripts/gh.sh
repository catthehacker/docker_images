#!/bin/bash -e
################################################################################
##  File:  github-cli.sh
##  Desc:  Installs GitHub CLI
##         Must be run as non-root user after homebrew
################################################################################
# source: https://github.com/actions/virtual-environments/blob/be27ebfdb31aece2c90fbe1984c1749cbd1b464c/images/linux/scripts/installers/github-cli.sh

# Install GitHub CLI
url=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | jq -r ".assets[].browser_download_url|select(contains(\"linux\") and contains(\"$(arch)\") and contains(\".deb\"))")
wget -q "$url" -O "/tmp/gh.deb"
apt install /tmp/gh.deb
