#!/bin/bash -e
################################################################################
##  File:  yq.sh
##  Desc:  Installs YQ
##  Supply chain security: YQ - checksum validation
################################################################################
# source: https://github.com/actions/runner-images/blob/5d6938f680075d63fa71f8aa70990866cd12884b/images/linux/scripts/installers/yq.sh

# Source the helpers for use with the script
. /imagegeneration/installers/helpers/install.sh

yq_arch() {
  case "$(uname -m)" in
    'aarch64') echo 'arm64' ;;
    'x86_64') echo 'amd64' ;;
    'armv7l') echo 'arm' ;;
    *) exit 1 ;;
  esac
}

# Download YQ
base_url="https://github.com/mikefarah/yq/releases/latest/download"
filename="yq_linux_$(yq_arch)"
yq_archive=$(download_with_retry "${base_url}/${filename}")
# Supply chain security - YQ
external_hash=$(get_hash_from_remote_file "${base_url}/checksums" "${filename} " "" " " "19")
use_checksum_comparison "${yq_archive}" "${external_hash}"
# Install YQ
sudo install "${yq_archive}" /usr/bin/yq
