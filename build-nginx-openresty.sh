#!/bin/sh -e

PKG_NAME=openresty
PKG_VERSION=1.9.7.1
PKG_SOURCE="ngx_openresty-$PKG_VERSION.tar.gz"
PKG_SOURCE_URL="http://openresty.org/download/$PKG_SOURCE"
PKG_SOURCE_MD5SUM=7bc29aa81af962c610f0d07656df85d9
PKG_DEPENDS='openssl pcre'

. "$PWD/env.sh"
PKG_BUILD_DIR="$BASE_BUILD_DIR/ngx_openresty-$PKG_VERSION"

. "$PWD/utils-nginx.sh"

do_patch() {
	cd "$PKG_BUILD_DIR"

	# NOTE: NGINX version ${PKG_VERSION%.*} was bundled
	patch -p0 <<"EOF"
--- bundle/nginx-1.9.7/auto/feature.orig	2015-12-22 20:52:59.000000000 +0800
+++ bundle/nginx-1.9.7/auto/feature	2015-12-22 20:53:37.000000000 +0800
@@ -39,8 +39,8 @@ int main() {
 END
 
 
-ngx_test="$CC $CC_TEST_FLAGS $CC_AUX_FLAGS $ngx_feature_inc_path \
-          -o $NGX_AUTOTEST $NGX_AUTOTEST.c $NGX_TEST_LD_OPT $ngx_feature_libs"
+ngx_test="$CC $ngx_feature_inc_path $CC_TEST_FLAGS $CC_AUX_FLAGS \
+          -o $NGX_AUTOTEST $NGX_AUTOTEST.c $ngx_feature_libs $NGX_TEST_LD_OPT"
 
 ngx_feature_inc_path=
 
EOF
}
