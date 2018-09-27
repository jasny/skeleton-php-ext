dnl $Id$
dnl config.m4 for extension skeleton

PHP_ARG_WITH(skeleton, for skeleton support,
[  --with-skeleton       Include skeleton support])

if test "$PHP_SKELETON" != "no"; then
  # TODO: Load external depenencies here  

  AC_DEFINE(HAVE_SKELETON, 1, [Whether you have skeleton support])
  PHP_NEW_EXTENSION(skeleton, skeleton.c, $ext_shared)
fi

