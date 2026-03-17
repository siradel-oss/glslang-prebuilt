#!/bin/bash

# SPDX-FileCopyrightText: 2026 Siradel
# SPDX-License-Identifier: MIT

set -e

VULKAN_SDK_VERSION=$1
GLSLANG_VERSION=$2

WINDOWS_VULKAN_SDK_URL=https://sdk.lunarg.com/sdk/download/$VULKAN_SDK_VERSION/windows/vulkansdk-windows-X64-$VULKAN_SDK_VERSION.exe
LINUX_VULKAN_SDK_URL=https://sdk.lunarg.com/sdk/download/$VULKAN_SDK_VERSION/linux/vulkansdk-linux-x86_64-$VULKAN_SDK_VERSION.tar.xz
LICENSE_URL=https://github.com/KhronosGroup/glslang/blob/vulkan-sdk-$VULKAN_SDK_VERSION/LICENSE.txt

mkdir -p $WINDOWS_ARTIFACT_NAME
mkdir -p $LINUX_ARTIFACT_NAME

echo "Fetching and extracting glslang for Windows"
curl -L -o vulkansdk-windows.exe $WINDOWS_VULKAN_SDK_URL
7z x -aoa -o$WINDOWS_ARTIFACT_NAME vulkansdk-windows.exe Bin/glslang.exe 

echo "Fetching and extracting glslang for Linux"
curl -L -o vulkansdk-linux.tar.xz $LINUX_VULKAN_SDK_URL
tar -xf vulkansdk-linux.tar.xz --strip-components=2 --directory=$LINUX_ARTIFACT_NAME $VULKAN_SDK_VERSION/x86_64/bin/glslang

echo "Fetching license"
curl -L -o LICENSE.TXT $LICENSE_URL
cp LICENSE.TXT $WINDOWS_ARTIFACT_NAME
cp LICENSE.TXT $LINUX_ARTIFACT_NAME

echo "Deleting downloaded files"
rm LICENSE.TXT
rm vulkansdk-windows.exe
rm vulkansdk-linux.tar.xz

echo "Creating tarballs"
tar -cJf $WINDOWS_ARTIFACT_NAME.tar.xz $WINDOWS_ARTIFACT_NAME
tar -cJf $LINUX_ARTIFACT_NAME.tar.xz $LINUX_ARTIFACT_NAME

echo "Deleting extracted directories"
rm -rf $WINDOWS_ARTIFACT_NAME
rm -rf $LINUX_ARTIFACT_NAME

echo "Calculating integrity hashes"
WINDOWS_INTEGRITY=$(openssl dgst -sha256 -binary $WINDOWS_ARTIFACT_NAME.tar.xz | openssl base64 -A | sed 's/^/sha256-/')
LINUX_INTEGRITY=$(openssl dgst -sha256 -binary $LINUX_ARTIFACT_NAME.tar.xz | openssl base64 -A | sed 's/^/sha256-/')

echo $WINDOWS_INTEGRITY
echo $LINUX_INTEGRITY

echo "Updating release info"

ASSET_BASE_URL=https://github.com/$GITHUB_REPOSITORY/releases/download/v$GLSLANG_VERSION
WINDOWS_URL=$ASSET_BASE_URL/$WINDOWS_ARTIFACT_NAME.tar.xz
LINUX_URL=$ASSET_BASE_URL/$LINUX_ARTIFACT_NAME.tar.xz

sed -e 's|%WINDOWS_URL%|'"$WINDOWS_URL"'|g' \
    -e 's|%WINDOWS_INTEGRITY%|'"$WINDOWS_INTEGRITY"'|g' \
    -e 's|%WINDOWS_PREFIX%|'"$WINDOWS_ARTIFACT_NAME"'|g' \
    -e 's|%LINUX_URL%|'"$LINUX_URL"'|g' \
    -e 's|%LINUX_INTEGRITY%|'"$LINUX_INTEGRITY"'|g' \
    -e 's|%LINUX_PREFIX%|'"$LINUX_ARTIFACT_NAME"'|g' \
    repo/glslang/release_info.tpl.bzl > repo/glslang/release_info.bzl
