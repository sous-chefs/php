# CHANGELOG for php

This file is used to list changes made in each version of php.

## v1.2.0

* Added ZendOptimizer+ opcache support
* Dropped source support
* Dropped older distro support
* Major code refactoring
* Added Vagrantfile

## v1.1.1:

Synced with upstream. More specifically:

* [COOK-1067] - support for PECL zend extensions
* [COOK-1348] - rescue Mixlib::ShellOut::ShellCommandFailed (chef 0.10.10)
* [COOK-1465] - fix pear extension template

## v1.1.0:

* Added numerous modules to be installed via recipes
* Removed Fedora compatibility (don't have the time to test on Fedora)
* Added the FPM recipe
* Created the FPM LWRP for dynamic FPM pool creation
* Added the Apache2 recipe for mod_php installation and configuration
* Added TMPFS support for uploads and sessions

## v1.0.2:

* [COOK-993] Add mhash-devel to centos php source libs
* [COOK-989] - bump version of php to 5.3.10
* Also download the .tar.gz instead of .tar.bz2 as bzip2 may not be in
  the base OS (e.g., CentOS 6 minimal)

## v1.0.0:

* Initial release of php
