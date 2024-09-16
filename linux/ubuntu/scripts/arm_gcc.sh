#!/bin/bash -e

################################################################################
##  File:  arm_gcc.sh
##  Desc:  Installs "gcc arm none eabi" manually 
### (since the packages were removed from apt)
################################################################################

. /etc/environment
. /imagegeneration/installers/helpers/etc-environment.sh


# Install arm gcc toolchain
printf "\n\t🐋 Installing .NET 🐋\t\n"

# Find version
ARM_TOOLCHAIN_VERSION=$(curl -s https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads | grep -Po '<h4>Version \K.+(?= <span)')

# Download binary archive
curl -Lo tooolchain.tar.xz "https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_TOOLCHAIN_VERSION}/binrel/arm-gnu-toolchain-${ARM_TOOLCHAIN_VERSION}-x86_64-arm-none-eabi.tar.xz"

export ARMGCC_ROOT=${ACT_TOOLSDIRECTORY}/gcc-arm-none-eabi

# unpack
mkdir ${ARMGCC_ROOT}
tar xf tooolchain.tar.xz --strip-components=1 -C ${ARMGCC_ROOT}

# write to path
export PATH=$PATH:${ARMGCC_ROOT}/bin
{
    echo "export PATH=$PATH:${ARMGCC_ROOT}/bin"
} | tee -a /etc/profile.d/gcc-arm-none-eabi.sh /etc/environment

prependEtcEnvironmentPath "${ARMGCC_ROOT}/bin"

# update profile
source /etc/profile

# test by echoing version
arm-none-eabi-gcc --version
arm-none-eabi-g++ --version

printf "\n\t🐋 Installed arm gcc toolchain 🐋\t\n"
