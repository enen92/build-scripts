#!/bin/bash -e
#
# Copyright 2015-2018 (c) Yousong Zhou
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# TMUX depends on libevent-dev to build.
#
#	sudo apt-get build-dep tmux
#
# tmux on Debian Wheezy 7 has version 1.6 (Fetched with command "tmux -V")
#
# CentOS 6.6 lacks a libevent version that fulfils tmux's requirement so that
# we have to build it manually here
#
# Note that currently running tmux may crash on installation of libevent...
#
# Newer versions are required for the following features to work
#
#  - TMUX plugins, >= 1.9, https://github.com/tmux-plugins/tpm
#  - set focus-events off, >= 1.8, see CHANGES file in source code.
#
PKG_NAME=tmux
PKG_VERSION=2.8
PKG_SOURCE="$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_SOURCE_URL="https://github.com/tmux/tmux/releases/download/$PKG_VERSION/$PKG_SOURCE"
PKG_SOURCE_MD5SUM=79ff2929a6422e45b490daa895cca4a2
PKG_DEPENDS='libevent'

. "$PWD/env.sh"
