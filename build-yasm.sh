#!/bin/bash -e
#
# Copyright 2016 (c) Yousong Zhou
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
PKG_NAME=yasm
PKG_VERSION=1.3.0
PKG_SOURCE="$PKG_NAME-${PKG_VERSION}.tar.gz"
PKG_SOURCE_URL="http://www.tortall.net/projects/yasm/releases/$PKG_SOURCE"
PKG_SOURCE_MD5SUM=fc9e586751ff789b34b1f21d572d96af

. "$PWD/env.sh"
