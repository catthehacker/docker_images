#!/bin/bash -e
################################################################################
##  File:  basic.sh
##  Desc:  Installs basic command line utilities and dev packages
################################################################################
# source: https://github.com/actions/virtual-environments/blob/5ae2170ebe90a53e1cdc9c507ed3e0f1471d6b66/images/linux/scripts/helpers/install.sh

apt-get update
common_packages=$(jq -r ".apt.common_packages[]" "/imagegeneration/toolset.json")
cmd_packages=$(jq -r ".apt.cmd_packages[]" "/imagegeneration/toolset.json")
# we depend on re-splitting behaviour here
# shellcheck disable=SC2068
apt-get install -y --no-install-recommends ${common_packages[@]} ${cmd_packages[@]}
