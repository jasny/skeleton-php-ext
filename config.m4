dnl $Id$
dnl config.m4 for extension skeleton

sinclude(./autoconf/pecl.m4)
sinclude(./autoconf/php-executable.m4)

PECL_INIT([skeleton])

PHP_ARG_ENABLE(skeleton, whether to enable skeleton, [ --enable-skeleton   Enable skeleton])

if test "$PHP_SKELETON" != "no"; then
  AC_DEFINE(HAVE_SKELETON, 1, [whether skeleton is enabled])
  PHP_NEW_EXTENSION(skeleton, skeleton.c, $ext_shared)

  PHP_ADD_MAKEFILE_FRAGMENT
  PHP_INSTALL_HEADERS([ext/skeleton], [php_skeleton.h])
fi
