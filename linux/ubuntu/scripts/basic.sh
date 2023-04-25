#!/bin/bash -e
################################################################################
##  File:  basic.sh
##  Desc:  Installs basic command line utilities and dev packages
################################################################################
# source: https://github.com/actions/virtual-environments/blob/5ae2170ebe90a53e1cdc9c507ed3e0f1471d6b66/images/linux/scripts/helpers/install.sh

apt-get update
# lib32z1 is not available for arm64 remove it via jq
case "$(uname -m)" in
  'x86_64') common_packages_filter="" ;;
  *) common_packages_filter="del(.apt.common_packages[] | select(. == \"lib32z1\"))" ;;
esac
common_packages=$(jq -r "$common_packages_filter .apt.common_packages[]" "/imagegeneration/toolset.json")
cmd_packages=$(jq -r ".apt.cmd_packages[]" "/imagegeneration/toolset.json")
# we depend on re-splitting behaviour here
# shellcheck disable=SC2068
apt-get install -y --no-install-recommends ${common_packages[@]} ${cmd_packages[@]}
