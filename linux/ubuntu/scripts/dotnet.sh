#!/bin/bash -e
################################################################################
##  File:  dotnet.sh
##  Desc:  Installs dotnet CLI
##         Must be run as non-root user after homebrew
################################################################################

# Install dotnet CLI
printf "\n\t🐋 Installing .NET 🐋\t\n"
#apt-get install -y dotnet-sdk-7.0 dotnet-sdk-6.0 dotnet-runtime-7.0 dotnet-runtime-6.0
curl -LO https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh
cat ./dotnet-install.sh
bash ./dotnet-install.sh --install-dir /opt/hostedtoolcache/dotnet --no-path --channel STS  # net 7.0
bash ./dotnet-install.sh --install-dir /opt/hostedtoolcache/dotnet --no-path --channel LTS  # net 6.0
rm ./dotnet-install.sh
export DOTNET_ROOT=/opt/hostedtoolcache/dotnet
export PATH=$PATH:$DOTNET_ROOT
{
  echo "DOTNET_ROOT=${DOTNET_ROOT}"
  echo "PATH=\$PATH:\$DOTNET_ROOT"
} | tee -a /etc/environment

which dotnet
dotnet --version
dotnet --info
#dotnet --list-sdks
#dotnet --list-runtimes
printf "\n\t🐋 Installed .NET 🐋\t\n"
