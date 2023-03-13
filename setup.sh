#!/bin/bash

set -o errexit

[[ $# -eq 0 ]] || exit 1

export KBUILD_BUILD_VERSION=1
export KBUILD_BUILD_USER=yuukaos
export KBUILD_BUILD_HOST=midori
export KBUILD_BUILD_TIMESTAMP="$(date -d "@$(git --no-pager show -s --format=%ct)")"

export ARCH=arm64
export CROSS_COMPILE=aarch64-none-elf-
export CROSS_COMPILE_ARM32=arm-none-eabi-
export VARIANT_DEFCONFIG=lineageos_h990_defconfig

if [ ! -d "/path/to/dir" ]

GCC_ARM64=$(pwd)/../gcc-arm-10.3-2021.07-x86_64-aarch64-none-elf/bin
GCC_ARM=$(pwd)/../gcc-arm-10.3-2021.07-x86_64-arm-none-eabi/bin
export PATH=:$PATH
export PATH=:$PATH

[ ! -d out ] && mkdir out

chrt -bp 0 $$

make -j$(nproc) -C $(pwd) O=out lineageos_h990_defconfig
make -j$(nproc) -C $(pwd) O=out

cp -v $(pwd)/out/arch/arm64/boot/Image.lz4-dtb $(pwd)/ak6/
zip -7qr kernel-$KBDUILD_BUILD_TIMESTAMP.zip $(pwd)/ak6/*
