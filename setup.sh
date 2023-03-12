#!/bin/bash

set -o errexit

[[ $# -eq 0 ]] || exit 1

export KBUILD_BUILD_VERSION=1
export KBUILD_BUILD_USER=yuukaos
export KBUILD_BUILD_HOST=midori
export KBUILD_BUILD_TIMESTAMP="$(date -d "@$(git --no-pager show -s --format=%ct)")"

export PATH=$(pwd)/../gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin:$PATH
export PATH=$(pwd)/../gcc-arm-10.3-2021.07-x86_64-arm-none-eabi/bin:$PATH

export ARCH=arm64
export CROSS_COMPILE=aarch64-none-elf-
export CROSS_COMPILE_ARM32=arm-none-eabi-
export VARIANT_DEFCONFIG=lineageos_h990_defconfig

[ ! -d out ] && mkdir out

chrt -bp 0 $$

make -j$(nproc) -C $(pwd) O=out lineageos_h990_defconfig
make -j$(nproc) -C $(pwd) O=out
