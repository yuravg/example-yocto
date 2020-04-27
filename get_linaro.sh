#!/usr/bin/env bash

# Get Linaro Toolchain

LINARO_VERSION=gcc-linaro-7.5.0-2019.12-i686_aarch64-linux-gnu.tar.xz
wget https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/aarch64-linux-gnu/$LINARO_VERSION
tar xvf $LINARO_VERSION
