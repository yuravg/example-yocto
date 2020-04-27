#!/usr/bin/env bash

# Add Linaro layers

bitbake-layers add-layer ../meta-linaro/meta-linaro-toolchain
bitbake-layers add-layer ../meta-linaro/meta-linaro
