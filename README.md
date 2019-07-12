![improved PHP library](https://user-images.githubusercontent.com/100821/46372249-e5eb7500-c68a-11e8-801a-2ee57da3e5e3.png)

# Skeleton PHP extension

[![Build Status](https://travis-ci.org/improved-php-library/skeleton-php-ext.svg?branch=master)](https://travis-ci.org/improved-php-library/skeleton-php-ext)
[![Build status](https://ci.appveyor.com/api/projects/status/7rof1vr8mv4kam17/branch/master?svg=true)](https://ci.appveyor.com/project/jasny/skeleton-php-ext/branch/master)

Skeleton project for PHP C-extension.

Includes Travis (Linux) and AppVeyor (Windows) configuration for continuous integration / platform tests.

---

## Requirements

* PHP 7.2+

## Installation

    phpize
    ./configure
    make
    make test
    make install

Add the following line to your `php.ini`

    extension=skeleton.so

To try out the extension, you can run the following command

    php -a -d extension=modules/skeleton.so

## Functions

### skeleton_nop

Return the input (which must be a string).

    string skeleton_nop(string input)

---

## Customize

To customize this skeleton for your own extension (e.g. `foo_bar`), edit the following files;

### config.m4 and config.w32

1. Do a search/replace for `HAVE_SKELETON, into `HAVE_FOO_BAR`.
2. Do a search/replace for the word `skeleton` into `foo_bar`.
3. If your extension name has name underscore, change the enable argument so it uses a dash.

    ```
    PHP_ARG_ENABLE(foo_bar, whether to enable foo_bar, [ --enable-foo-bar   Enable foo_bar])
    ```
    
    ```
    ARG_ENABLE("foo-bar", "enable foo_bar", "no");
    ```

### php_skeleton.h

1. Rename the file using your extension name `php_foo_bar.h`.
2. Do a search/replace for `PHP_SKELETON_H` into `PHP_FOO_BAR_H`.
3. Do a search/replace for `HAVE_SKELETON` into `HAVE_FOO_BAR`.
4. Change the `zend_module_entry` from `skeleton_module_entry` to `foo_bar_module_entry`

### skeleton.c

1. Rename the file using your extension name `foo_bar.c`.
2. Do a search/replace for `PHP_SKELETON_H` into `PHP_FOO_BAR_H`.
3. Change `PHP_SKELETON_EXTNAME` to `PHP_FOO_BAR_EXTNAME`
4. Change the `zend_module_entry` from `skeleton_module_entry` to `foo_bar_module_entry`
5. In `ZEND_GET_MODULE` replace `skeleton` to `foo_bar`.

### .appveyor.yml and .travis.yml

Change `skeleton` with your extension name for the `EXTNAME` env var.

```
env:
  EXTNAME: foo_bar
```

#### Deployment

Both Travis and AppVeyor are configured to automatically deploy the generated packages to
[GitHub releases](https://help.github.com/en/articles/creating-releases). In order to do so, you need to specify a
GitHub API key.

1. Create a new [Personal access token](https://github.com/settings/tokens) on GitHub via developer settings with the
    `public_repo` privilege.
2. For AppVeyor, encrypt the token using the online [Encrypt Yaml](https://ci.appveyor.com/tools/encrypt) tool. Replace
    `<your encrypted toke>` for the encrypted value in `.appveyor.yml`.
3. For Travis, install the Travis CLI (`gem install travis`) and use `travis encrypt` to encrypt the token. Replace
    `<your encrypted toke>` for the encrypted value in `.travis.yml`.

### package.xml

Edit the PECL package config if you wish to publish your extension to PECL. Otherwise delete this file.

### LICENSE

Update the LICENSE with your (company) name and the year.

_You may put your name in CREDITS, but don't add you e-mail address or the build may fail._

### Replace example function

Edit the header (`php_foo_bar.h`) and source (`foo_bar.c`) file, replace the declaration and implementation of
`PHP_FUNCTION(skeleton_nop)` with your own function(s). Also update `zend_function_entry functions` and create
the argument info for each function.


## Getting started with PHP internals

_There is a lot of information about the internals and writing PHP extensions online. Unfortunately but this information
is often outdated, including the information found in the PHP manual._

* [PHP extension sample](https://github.com/ThomasWeinert/php-extension-sample) - Collection of sample features for a
    php extension
* [phpinternals.net](https://phpinternals.net/) - An (accurate but incomplete) reference guide of PHP macros and
    functions
* [PHP source code](https://github.com/php/php-src) - If all else fails, look up examples in the PHP source code
