#!/bin/bash

# Usage: ./build.sh <device_codename>

DEVICE_CODENAME=$1

if [ -z "$DEVICE_CODENAME" ]; then
    echo "Error: Device codename not provided"
    echo "Usage: ./build.sh <device_codename>"
    exit 1
fi

cd kernel_xiaomi_sdm845

# Export required variables
export ARCH=arm64
export KBUILD_BUILD_HOST="Hayasaka-Github-actions-Onelots"

# Configure kernel
make O=out ARCH=arm64 vendor/xiaomi/mi845_defconfig vendor/debugfs.config vendor/kernelsu.config vendor/xiaomi/${DEVICE_CODENAME}.config V=1
make O=out ARCH=arm64 olddefconfig

# Build kernel
make -j$(nproc --all) O=out -j"$(nproc --all)" \
    ARCH=arm64 \
    CC="ccache clang" \
    LLVM=1 \
    LLVM_IAS=1 \
    LD=ld.lld \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi-