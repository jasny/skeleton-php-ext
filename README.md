# Skeleton PHP extension

[![Build Status](https://travis-ci.org/jasny/skeleton-php-ext.svg?branch=master)](https://travis-ci.org/jasny/skeleton-php-ext)
[![Build status](https://ci.appveyor.com/api/projects/status/7rof1vr8mv4kam17/branch/master?svg=true)](https://ci.appveyor.com/project/jasny/skeleton-php-ext/branch/master)

Skeleton project for PHP C-extension.

Include Travis (Linux) and AppVeyor (Windows) configuration for continuous integration / platform tests.

Visit [phpinternals.net](https://phpinternals.net/) to get started. Check the `TODO:` comments in the
source and build files.

_There is also information about the externals in the PHP manual, but this information is often outdated
or confusing._

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
