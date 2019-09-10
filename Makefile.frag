clean-tests:
	rm -f tests/*.diff tests/*.exp tests/*.log tests/*.out tests/*.php tests/*.sh

mrproper: clean clean-tests
	rm -rf autom4te.cache build modules vendor
	rm -f acinclude.m4 aclocal.m4 config.guess config.h config.h.in config.log config.nice config.status config.sub \
		configure configure.ac install-sh libtool ltmain.sh Makefile Makefile.fragments Makefile.global \
		Makefile.objects missing mkinstalldirs run-tests.php *~

info: $(all_targets)
	"$(PHP_EXECUTABLE)" -d "extension=$(phplibdir)/$(PHP_PECL_EXTENSION).so" --re "$(PHP_PECL_EXTENSION)"

package.xml: php_$(PHP_PECL_EXTENSION).h
	$(PHP_EXECUTABLE) build-packagexml.php

.PHONY: all clean install distclean test prof-gen prof-clean prof-use clean-tests mrproper info
