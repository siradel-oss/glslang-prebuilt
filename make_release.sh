#!/bin/bash

# SPDX-FileCopyrightText: 2026 Siradel
# SPDX-License-Identifier: MIT

set -e

GLSLANG_VERSION=$1

ASSET_BASE_URL=https://github.com/KhronosGroup/glslang/releases/download/$GLSLANG_VERSION

# Prints the SRI integrity hash of an upstream glslang release asset
compute_integrity() {
    local ARCHIVE=glslang-$GLSLANG_VERSION-$1-release.zip
    curl -fsSL -o $ARCHIVE $ASSET_BASE_URL/$ARCHIVE
    openssl dgst -sha256 -binary $ARCHIVE | openssl base64 -A | sed 's/^/sha256-/'
    rm $ARCHIVE
}

echo "Calculating integrity hashes"
LINUX_INTEGRITY=$(compute_integrity linux-x86_64)
WINDOWS_INTEGRITY=$(compute_integrity windows-x86_64)

echo $LINUX_INTEGRITY
echo $WINDOWS_INTEGRITY

echo "Fetching license"
curl -fsSL -o repo/glslang/LICENSE.txt https://raw.githubusercontent.com/KhronosGroup/glslang/$GLSLANG_VERSION/LICENSE.txt

echo "Updating release info"
sed -e 's|%VERSION%|'"$GLSLANG_VERSION"'|g' \
    -e 's|%LINUX_INTEGRITY%|'"$LINUX_INTEGRITY"'|g' \
    -e 's|%WINDOWS_INTEGRITY%|'"$WINDOWS_INTEGRITY"'|g' \
    repo/glslang/release_info.tpl.bzl > repo/glslang/release_info.bzl
