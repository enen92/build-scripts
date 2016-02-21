#!/bin/sh -e

PKG_NAME=libsodium
PKG_VERSION=1.0.8
PKG_SOURCE="$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_SOURCE_URL="https://download.libsodium.org/libsodium/releases/$PKG_SOURCE"
PKG_SOURCE_MD5SUM=0a66b86fd3aab3fe4c858edcd2772760

. "$PWD/env.sh"
