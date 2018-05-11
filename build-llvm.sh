#!/bin/bash -e
#
# Copyright 2017 (c) Yousong Zhou
#
# LLVM as of 3.9.1 requires at least
#
#  - cmake version 3.4.3
#  - GCC 4.8
#
# Links
#
#  - http://releases.llvm.org/download.html
#  - http://www.llvm.org/docs/GettingStarted.html
#
#    - Hardware/software requirements
#    - Installation howto

LLVM_VERSION=6.0.0

PKG_NAME=llvm
PKG_VERSION=$LLVM_VERSION
PKG_SOURCE="$PKG_NAME-${PKG_VERSION}.src.tar.xz"
PKG_SOURCE_URL="http://llvm.org/releases/$PKG_VERSION/$PKG_SOURCE"
PKG_SOURCE_MD5SUM=788a11a35fa62eb008019b37187d09d2
PKG_DEPENDS='cmake zlib gcc-cross-pass2'
PKG_CMAKE=1

PKG_clang_NAME=clang
PKG_clang_VERSION=$LLVM_VERSION
PKG_clang_SOURCE="cfe-$PKG_clang_VERSION.src.tar.xz"
PKG_clang_SOURCE_URL="http://llvm.org/releases/$PKG_clang_VERSION/$PKG_clang_SOURCE"
PKG_clang_SOURCE_MD5SUM=121b3896cb0c7765d690acc5d9495d24

# "compiler-rt" runtime libraries, http://compiler-rt.llvm.org/index.html
#
# - builtins
# - sanitizer runtimes
# - profile
# - BlocksRuntime
PKG_compiler_rt_NAME=compiler-rt
PKG_compiler_rt_VERSION=$LLVM_VERSION
PKG_compiler_rt_SOURCE="compiler-rt-$PKG_compiler_rt_VERSION.src.tar.xz"
PKG_compiler_rt_SOURCE_URL="http://llvm.org/releases/$PKG_compiler_rt_VERSION/$PKG_compiler_rt_SOURCE"
PKG_compiler_rt_SOURCE_MD5SUM=ba6368e894b5528e527d86a69d8533c6

PKG_libcxx_NAME=libcxx
PKG_libcxx_VERSION=$LLVM_VERSION
PKG_libcxx_SOURCE="libcxx-$PKG_libcxx_VERSION.src.tar.xz"
PKG_libcxx_SOURCE_URL="http://llvm.org/releases/$PKG_libcxx_VERSION/$PKG_libcxx_SOURCE"
PKG_libcxx_SOURCE_MD5SUM=4ecad7dfd8ea636205d3ffef028df73a

PKG_libcxxabi_NAME=libcxxabi
PKG_libcxxabi_VERSION=$LLVM_VERSION
PKG_libcxxabi_SOURCE="libcxxabi-$PKG_libcxxabi_VERSION.src.tar.xz"
PKG_libcxxabi_SOURCE_URL="http://llvm.org/releases/$PKG_libcxxabi_VERSION/$PKG_libcxxabi_SOURCE"
PKG_libcxxabi_SOURCE_MD5SUM=9d06327892fc5d8acec4ef2e2821ab3d

# A linker, https://lld.llvm.org/
#
# To use it
#
#	./clang \
#		--sysroot=$HOME/git-repo/lede-project/lede/staging_dir/toolchain-mips_24kc_gcc-7.3.0_glibc \
#		-target mips-openwrt-linux-gnu \
#		-mfloat-abi=soft \
#		-fuse-ld=lld \
#		-Wl,-dynamic-linker -Wl,/lib/ld-musl-mips-sf.so.1 \
#		-v \
#		-o a a.c
#
#	./clang \
#		--sysroot=$HOME/git-repo/lede-project/lede/staging_dir/toolchain-mips_24kc_gcc-7.3.0_musl \
#		-target mips-openwrt-linux-musl \
#		-mfloat-abi=soft \
#		-fuse-ld=lld \
#		-Wl,-dynamic-linker -Wl,/lib/ld-musl-mips-sf.so.1 \
#		-v \
#		-o a a.c
#
# LLVM is born cross-capable ;) Linker will need -sysroot to find "crt*.o" and
# "libgcc*" under "$sysroot/lib/gcc/$target".  The simple test above have the
# following result
#
#  - glibc: compiles and run with OpenWrt malta musl machine
#  - musl: compiles but segfault when running in OpenWrt malta musl machine
#
#		root@OpenWrt:/tmp# /tmp/a
#		[  677.202865] do_page_fault(): sending SIGSEGV to a for invalid write access to 00020000
#		[  677.207014] epc = 77f6e8f0 in libc.so[77eeb000+92000]
#		[  677.210336] ra  = 77f6e3b8 in libc.so[77eeb000+92000]
#
PKG_lld_NAME=lld
PKG_lld_VERSION=$LLVM_VERSION
PKG_lld_SOURCE="lld-$PKG_lld_VERSION.src.tar.xz"
PKG_lld_SOURCE_URL="http://llvm.org/releases/$PKG_lld_VERSION/$PKG_lld_SOURCE"
PKG_lld_SOURCE_MD5SUM=7ab2612417477b03538f11cd8b5e12f8

# test-suite too big: about 113MB as of version 3.9.1
PKG_test_suite_NAME=test-suite
PKG_test_suite_VERSION=$LLVM_VERSION
PKG_test_suite_SOURCE="test-suite-$PKG_test_suite_VERSION.src.tar.xz"
PKG_test_suite_SOURCE_URL="http://llvm.org/releases/$PKG_test_suite_VERSION/$PKG_test_suite_SOURCE"
PKG_test_suite_SOURCE_MD5SUM=x

. "$PWD/env.sh"

download_extra() {
	download_http "$PKG_clang_SOURCE"		"$PKG_clang_SOURCE_URL"			"$PKG_clang_SOURCE_MD5SUM"
	download_http "$PKG_lld_SOURCE"			"$PKG_lld_SOURCE_URL"			"$PKG_lld_SOURCE_MD5SUM"
	download_http "$PKG_compiler_rt_SOURCE"	"$PKG_compiler_rt_SOURCE_URL"	"$PKG_compiler_rt_SOURCE_MD5SUM"
	download_http "$PKG_libcxx_SOURCE"		"$PKG_libcxx_SOURCE_URL"		"$PKG_libcxx_SOURCE_MD5SUM"
	download_http "$PKG_libcxxabi_SOURCE"	"$PKG_libcxxabi_SOURCE_URL"		"$PKG_libcxxabi_SOURCE_MD5SUM"
}

prepare_extra() {
	unpack "$BASE_DL_DIR/$PKG_clang_SOURCE"			"$PKG_SOURCE_DIR/tools/"	"s:^[^/]\\+:clang:"
	unpack "$BASE_DL_DIR/$PKG_lld_SOURCE"			"$PKG_SOURCE_DIR/tools/"	"s:^[^/]\\+:lld:"
	unpack "$BASE_DL_DIR/$PKG_compiler_rt_SOURCE"	"$PKG_SOURCE_DIR/projects/"	"s:^[^/]\\+:compiler-rt:"
	unpack "$BASE_DL_DIR/$PKG_libcxx_SOURCE"		"$PKG_SOURCE_DIR/projects/"	"s:^[^/]\\+:libcxx:"
	unpack "$BASE_DL_DIR/$PKG_libcxxabi_SOURCE"		"$PKG_SOURCE_DIR/projects/"	"s:^[^/]\\+:libcxxabi:"
}

. $PWD/utils-toolchain.sh

ORIG_INSTALL_PREFIX="$INSTALL_PREFIX"
TOOLCHAIN_DIR_BASE="$ORIG_INSTALL_PREFIX/toolchain"
INSTALL_PREFIX="$TOOLCHAIN_DIR_BASE/llvm-$LLVM_VERSION"

GNU_TOOLCHAIN_DIR="$TOOLCHAIN_DIR_BASE/$GNU_TOOLCHAIN_NAME"
GNU_TOOLCHAIN_DIR_BIN="$GNU_TOOLCHAIN_DIR/bin"
GNU_TOOLCHAIN_DIR_LIB="$GNU_TOOLCHAIN_DIR/lib"

EXTRA_LDFLAGS+=( -Wl,--dynamic-linker="$GNU_TOOLCHAIN_DIR_LIB/ld-linux-x86-64.so.2" )
EXTRA_LDFLAGS+=( -Wl,-rpath "$GNU_TOOLCHAIN_DIR_LIB" )
EXTRA_LDFLAGS+=( -L"$GNU_TOOLCHAIN_DIR_LIB" )

# Requires at least GCC 4.8
CMAKE_ENVS+=(
	CC="$GNU_TOOLCHAIN_DIR_BIN/$TRI_TARGET-gcc"
	CXX="$GNU_TOOLCHAIN_DIR_BIN/$TRI_TARGET-g++"
)
CMAKE_ARGS+=(
	-G 'Unix Makefiles'
)
