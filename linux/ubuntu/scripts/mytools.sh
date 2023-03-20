#!/bin/bash
# shellcheck disable=SC1091,SC2174,SC2016

set -Eeuo pipefail

. /etc/environment

printf "\n\t🐋 Installing NVM tools 🐋\t\n"
VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r '.tag_name')
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$VERSION/install.sh" | bash
export NVM_DIR=$HOME/.nvm
echo "NVM_DIR=$HOME/.nvm" | tee -a /etc/environment

# Expressions don't expand in single quotes, use double quotes for that.shellcheck(SC2016)
# shellcheck disable=SC2016
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' | tee -a /etc/skel/.bash_profile

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

printf "\n\t🐋 Installed NVM 🐋\t\n"
nvm --version

# node 12 and 16 are installed already in act-*
versions=("14")

printf "\n\t🐋 Installing METAGEN 🐋\t\n"
npm install -g https://github.com/kagekirin/metagen-js/tarball/main
which metagen
metagen --version
metagen --help

printf "\n\t🐋 Installing version tools 🐋\t\n"
npm install -g https://github.com/kagekirin/node-package-version/tarball/main
which node-package-version
node-package-version --version
node-package-version --help
npm install -g https://github.com/kagekirin/csproj-version/tarball/main
which csproj-version
csproj-version --version
csproj-version --help
npm install -g https://github.com/kagekirin/unity-bundle-version/tarball/main
which unity-bundle-version
unity-bundle-version --version
unity-bundle-version --help
npm install -g https://github.com/kagekirin/csproj-dependency-version/tarball/main
which csproj-dependency-version
csproj-dependency-version --version
csproj-dependency-version --help

printf "\n\t🐋 Installing Google Cloud 🐋\t\n"
apt-get update -y -qq
apt-get install -y apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
apt-get update  -y -qq
apt-get install -y google-cloud-cli
npm install -g google-artifactregistry-auth

printf "\n\t🐋 Installing Clang 🐋\t\n"
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu `lsb_release -sc` main universe restricted multiverse"
add-apt-repository -y "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-16 main"
bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
apt-get install -y clang-format clang-tidy clang-tools clang clangd

printf "\n\t🐋 Installing Ninja 🐋\t\n"
curl -LO https://github.com/ninja-build/ninja/releases/download/v1.10.2/ninja-linux.zip
unzip -d /ninja-build ninja-linux.zip
ls /ninja-build
export PATH=$PATH:/ninja-build
echo 'export PATH=$PATH:/ninja-build' >> $BASH_ENV
ninja --version

printf "\n\t🐋 Installing Zig 🐋\t\n"
curl -LO https://ziglang.org/builds/zig-linux-x86_64-0.11.0-dev.612+8ccb9a6ad.tar.xz
tar xf zig-linux-x86_64-0.11.0-dev.612+8ccb9a6ad.tar.xz
mv zig-linux-x86_64-0.11.0-dev.612+8ccb9a6ad /zig
ls -alG /zig
/zig/zig version
export PATH=$PATH:/zig
echo 'export PATH=$PATH:/zig' >> $BASH_ENV
zig version
zig targets

printf "\n\t🐋 Installing .NET 🐋\t\n"
curl -LO https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh
cat ./dotnet-install.sh
bash ./dotnet-install.sh --channel STS
bash ./dotnet-install.sh --channel LTS
echo $PATH
export PATH=$PATH:/root/.dotnet
echo 'export PATH=$PATH:/root/.dotnet' >>  $BASH_ENV
which dotnet
dotnet --version
dotnet --info
dotnet --list-sdks
dotnet --list-runtimes
