/*
  +----------------------------------------------------------------------+
  | Skeleton PHP extension                                               |
  +----------------------------------------------------------------------+
  | Copyright (c) 2018 NAME                                              |
  +----------------------------------------------------------------------+
  | Permission is hereby granted, free of charge, to any person          |
  | obtaining a copy of this software and associated documentation files |
  | (the "Software"), to deal in the Software without restriction,       |
  | including without limitation the rights to use, copy, modify, merge, |
  | publish, distribute, sublicense, and/or sell copies of the Software, |
  | and to permit persons to whom the Software is furnished to do so,    |
  | subject to the following conditions:                                 |
  |                                                                      |
  | The above copyright notice and this permission notice shall be       |
  | included in all copies or substantial portions of the Software.      |
  |                                                                      |
  | THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,      |
  | EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF   |
  | MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                |
  | NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS  |
  | BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN   |
  | ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN    |
  | CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE     |
  | SOFTWARE.                                                            |
  +----------------------------------------------------------------------+
  | Author: NAME <EMAIL@EXAMPLE.COM>                                     |
  +----------------------------------------------------------------------+
*/

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#include "php.h"
#include "php_ini.h"
#include "php_skeleton.h"
#include "zend_exceptions.h"
#include "ext/standard/info.h"

#if HAVE_SKELETON

/* Argument info for each function, used for reflection */
ZEND_BEGIN_ARG_INFO_EX(arginfo_skeleton_nop, 0, 1, 0)
    ZEND_ARG_TYPE_INFO(0, str, IS_STRING, 1)
ZEND_END_ARG_INFO()

/* Add all functions. (Keep PHP_FE_END as last element) */
static const zend_function_entry functions[] = {
    PHP_FE(skeleton_nop, arginfo_skeleton_nop)
    PHP_FE_END
};

zend_module_entry skeleton_module_entry = {
    STANDARD_MODULE_HEADER,
    PHP_SKELETON_EXTNAME,
    functions,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    PHP_SKELETON_VERSION,
    STANDARD_MODULE_PROPERTIES
};

#ifdef COMPILE_DL_SKELETON
ZEND_GET_MODULE(skeleton)
#endif

/* Replace the example function with something better :) */
PHP_FUNCTION(skeleton_nop)
{
    zend_string *str;

    ZEND_PARSE_PARAMETERS_START_EX(ZEND_PARSE_PARAMS_THROW, 1, 1)
        Z_PARAM_STR(str)
    ZEND_PARSE_PARAMETERS_END();

    RETVAL_STR(str);
}

#endif
