#!/bin/bash
# shellcheck disable=SC1091

set -Eeuxo pipefail

. /etc/environment

printf "\n\t🐋 Installing PowerShell 🐋\t\n"

# While an linux/amd64 platform installation can use apt-get, the linux/arm64
# platform installation can't as described here:
# https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1#support-for-arm-processors
#
# Due to that, we rely on the binary installation method for both platforms, as
# described here:
# https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1#linux
#
# TODO: think of a more robust installation for multiple architectures

ARCH=$(uname -m)
if [ "$ARCH" = x86_64 ]; then ARCH=x64; fi
if [ "$ARCH" = aarch64 ]; then ARCH=arm64; fi
if [ "$ARCH" = armv7l ]; then ARCH=arm32; fi
VER=$(curl --silent "https://api.github.com/repos/PowerShell/PowerShell/releases/latest" | jq -r .tag_name)
curl -L -o /tmp/powershell.tar.gz "https://github.com/PowerShell/PowerShell/releases/download/$VER/powershell-${VER:1}-linux-$ARCH.tar.gz"
sudo mkdir -p "/opt/microsoft/powershell/${VER:1:1}"
sudo tar zxf /tmp/powershell.tar.gz -C "/opt/microsoft/powershell/${VER:1:1}"
sudo chmod +x "/opt/microsoft/powershell/${VER:1:1}/pwsh"
sudo ln -s "/opt/microsoft/powershell/${VER:1:1}/pwsh" /usr/bin/pwsh
rm /tmp/powershell.tar.gz

printf "\n\t🐋 Installed PWSH 🐋\t\n"
pwsh -v

case "$(uname -m)" in
  'aarch64')
    printf "\n\t🐋 Skip Installing PowerShell modules, due to crash maybe caused by qemu 🐋\t\n"
    exit 0
    ;;
  *)
    modules=("MarkdownPS" "Pester" "PSScriptAnalyzer")
    ;;
esac
printf "\n\t🐋 Installing PowerShell modules 🐋\t\n"

pwsh -nol -nop -c "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted"

for mod in "${modules[@]}"; do
  printf "\n\t🧨 Installing %s 🧨\t\n" "${mod}"
  pwsh -nol -nop -c "\$ProgressPreference = \"SilentlyContinue\" ; Install-Module -Name ${mod} -Scope AllUsers -SkipPublisherCheck -Force"
done
