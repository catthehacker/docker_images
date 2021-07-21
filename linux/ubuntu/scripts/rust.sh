#!/bin/bash

set -Eeuxo pipefail

# source environment because Linux is beautiful and not really confusing like Windows, also you are apparently not supposed to source that file because it's not conforming to standard shell format but we already fix that in base image
# yes, this is sarcasm
# shellcheck disable=SC1091
. /etc/environment

export RUSTUP_HOME=/usr/share/rust/.rustup
export CARGO_HOME=/usr/share/rust/.cargo

printf "\n\t🐋 Installing dependencies 🐋\t\n"
apt-get -yq update
apt-get -yq install build-essential llvm

printf "\n\t🐋 Installing Rust 🐋\t\n"
curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=stable --profile=minimal

# shellcheck disable=SC1091
source "${CARGO_HOME}/env"

rustup component add rustfmt clippy
cargo install --locked bindgen cbindgen cargo-audit cargo-outdated
chmod -R 777 "$(dirname "${RUSTUP_HOME}")"

# cleanup
rm -rf "${CARGO_HOME}/registry/*"

sed "s|PATH=|PATH=${CARGO_HOME}/bin:|g" -i /etc/environment

cd /root
ln -sf "${CARGO_HOME}" .cargo
ln -sf "${RUSTUP_HOME}" .rustup
echo "RUSTUP_HOME=${RUSTUP_HOME}" >>/etc/environment
echo "CARGO_HOME=${CARGO_HOME}" >>/etc/environment

printf "\n\t🐋 Installed RUSTUP 🐋\t\n"
rustup -V

printf "\n\t🐋 Installed CARGO 🐋\t\n"
cargo -V

printf "\n\t🐋 Installed RUSTC 🐋\t\n"
rustc -V

printf "\n\t🐋 Cleaning image 🐋\t\n"
apt-get clean
rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/* /tmp/* || echo 'Failed to delete directories'

printf "\n\t🐋 Cleaned up image 🐋\t\n"
