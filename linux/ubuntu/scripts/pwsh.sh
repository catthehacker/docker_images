#!/bin/bash

set -Eeuxo pipefail

printf "\n\t🐋 Installing PowerShell 🐋\t\n"
sudo apt-get -yq update
sudo apt-get -yq install powershell

printf "\n\t🐋 Installed PWSH 🐋\t\n"
pwsh -v

printf "\n\t🐋 Installing PowerShell modules 🐋\t\n"
modules=("MarkdownPS" "Pester" "PSScriptAnalyzer")

for mod in "${modules[@]}"; do
    printf "\n\t🐋 Installing %s 🐋\t\n" "${mod}"
    pwsh -nol -nop -c "Install-Module -Name ${mod} -Scope AllUsers -SkipPublisherCheck -Force"
done

printf "\n\t🐋 Cleaning image 🐋\t\n"
apt-get clean
rm -rf /var/cache/* /var/log/* /var/lib/apt/lists/* /tmp/* || echo 'Failed to delete directories'

printf "\n\t🐋 Cleaned up image 🐋\t\n"
