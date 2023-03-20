#!/bin/bash -e
################################################################################
##  File:  github-cli.sh
##  Desc:  Installs GitHub CLI
##         Must be run as non-root user after homebrew
################################################################################
# source: https://github.com/actions/virtual-environments/blob/be27ebfdb31aece2c90fbe1984c1749cbd1b464c/images/linux/scripts/installers/github-cli.sh

# Install GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt-get update  -y -qq
sudo apt-get install gh
