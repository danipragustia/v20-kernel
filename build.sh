#!/bin/bash

set -o errexit

[[ $# -eq 0 ]] || exit 1

apt-get -y install bc build-essential libncurses5-dev bzip2 git bc

export KBUILD_BUILD_VERSION=1
export KBUILD_BUILD_USER=yuukaos
export KBUILD_BUILD_HOST=midori
export KBUILD_BUILD_TIMESTAMP="$(date -d "@$(git --no-pager show -s --format=%ct)")"

export ARCH=arm64
export CROSS_COMPILE=aarch64-none-elf-
export CROSS_COMPILE_ARM32=arm-none-eabi-
export VARIANT_DEFCONFIG=lineageos_h990_defconfig

# Toolchains
GCC_ARM64=$(pwd)/../gcc-arm-10.3-2021.07-x86_64-aarch64-none-elf/bin
GCC_ARM=$(pwd)/../gcc-arm-10.3-2021.07-x86_64-arm-none-eabi/bin
if [ ! -d "$GCC_ARM" ]; then
    curl "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.3-2021.07/binrelg/cc-arm-10.3-2021.07-x86_64-aarch64-none-elf.tar.xz" --output $(pwd)/../arm.tar.xz
    tar -xf $(pwd)/../arm.tar.xz
fi
if [ ! -d "$GCC_ARM64"]; then
    curl "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07-x86_64-arm-none-eabi.tar.xz" --output $(pwd)/../arm64.tar.xz
    tar -xf $(pwd)/../arm.tar.xz
fi
export PATH=:$GCC_ARM:$GCC_ARM64:$PATH

[ ! -d out ] && mkdir out

chrt -bp 0 $$

make -j$(nproc) -C $(pwd) O=out lineageos_h990_defconfig
make -j$(nproc) -C $(pwd) O=out

cp -v $(pwd)/out/arch/arm64/boot/Image.lz4-dtb $(pwd)/ak6/
zip -7qr kernel-$KBDUILD_BUILD_TIMESTAMP.zip $(pwd)/ak6/*
