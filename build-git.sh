#!/bin/bash -e
#
# Copyright 2015-2017 (c) Yousong Zhou
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# Extra features support
#
#	yum -y groupinstall "Development Tools"
#	yum-builddep git-email
#
#	# Manuals
#	sudo yum install -y asciidoc xmlto
#
# Sometimes we need to install several perl modules for the git-send-email to work
#
#	sudo yum install -y perl-CPAN
#	sudo cpan Net::SMTP::SSL MIME::Base64 Authen::SASL
#
# Manpages and perl bindings are installed with readonly permissions 0444.  To overwrite previous install, clean them
#
#	rm -rfv /home/yousong/.usr/share/man/man3/Git*
#	rm -rfv /home/yousong/.usr/share/perl/5.14.2/Git*
#
PKG_NAME=git
PKG_VERSION=2.16.3
PKG_SOURCE="$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_SOURCE_URL="https://www.kernel.org/pub/software/scm/git/$PKG_SOURCE"
PKG_SOURCE_MD5SUM=1b75ee082169dfcad321a4dc13b37009
PKG_DEPENDS='curl expat libiconv openssl zlib'

. "$PWD/env.sh"

# Git's handwritten Makefile does not detect build-dep then build/install
# manpages by default.
compile() {
	build_compile_make all
	build_compile_make man
}

staging() {
	build_staging install
	build_staging install-man
}
