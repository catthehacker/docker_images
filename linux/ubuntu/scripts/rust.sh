#!/bin/bash
# shellcheck disable=SC1091

set -Eeuxo pipefail

. /etc/environment
. /imagegeneration/installers/helpers/os.sh

export RUSTUP_HOME=/usr/share/rust/.rustup
export CARGO_HOME=/usr/share/rust/.cargo

printf "\n\t🐋 Installing dependencies 🐋\t\n"
apt-get -yq update
apt-get -yq install build-essential llvm libssl-dev

printf "\n\t🐋 Installing Rust 🐋\t\n"
curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=stable --profile=minimal

source "${CARGO_HOME}/env"

rustup component add rustfmt clippy

cargo install --locked bindgen-cli cbindgen cargo-audit cargo-outdated

chmod -R 777 "$(dirname "${RUSTUP_HOME}")"

# cleanup
rm -rf "${CARGO_HOME}/registry/*"

sed "s|PATH=|PATH=${CARGO_HOME}/bin:|g" -i /etc/environment

cd /root
ln -sf "${CARGO_HOME}" .cargo
ln -sf "${RUSTUP_HOME}" .rustup
{
  echo "RUSTUP_HOME=${RUSTUP_HOME}"
  echo "CARGO_HOME=${CARGO_HOME}"
} | tee -a /etc/environment

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
