@echo off

setlocal enableextensions enabledelayedexpansion

	REM TODO: build external libraries

	REM set up PHP
	mkdir C:\projects\php-sdk >NUL 2>NUL
	cd C:\projects\php-sdk
    wget %PHP_SDK_BINARY_TOOLS_URL%/%PHP_SDK_BINARY_TOOLS_PACKAGE% --no-check-certificate -q -O %PHP_SDK_BINARY_TOOLS_PACKAGE%
    7z x -y %PHP_SDK_BINARY_TOOLS_PACKAGE%
	cmd /c bin\phpsdk_buildtree.bat phpdev
	pushd phpdev
	ren vc9 vc14
	pushd vc14\x64
    git clone https://git.php.net/repository/php-src.git
	cd php-src
	git checkout PHP-%PHP_REL%
	cd ..
	wget %PHP_DEPS_URL%/%PHP_DEPS_PACKAGE% --no-check-certificate -q -O %PHP_DEPS_PACKAGE%
	7z x -y %PHP_DEPS_PACKAGE%
	popd
	popd

	REM copy the extension into the PHP tree
	mkdir c:\projects\php-sdk\phpdev\vc14\x64\php-src\ext\skeleton
	xcopy c:\projects\skeleton-php-ext\*.* c:\projects\php-sdk\phpdev\vc14\x64\php-src\ext\skeleton /s/e/v
	pushd c:\projects\php-sdk\phpdev\vc14\x64\php-src\ext\skeleton
	del /q CREDITS
	popd
	
	REM The bison utility is needed for the PHP build, so add MSYS to the path.
	REM Note: Add to the end to ensure MSVC tools are found firts.
	set PATH=%PATH%;c:\MinGW\msys\1.0\bin

	REM perform the build
	cmd /c bin\phpsdk_setvars.bat
	pushd phpdev\vc14\x64\php-src
	cmd /c buildconf --force
	cmd /c configure --disable-all --enable-cli --with-skeleton=shared
	nmake
	popd

	REM TODO: debugging

	dir php_skeleton.dll /s
	dir php.exe /s
	dir php*.dll /s

endlocal

