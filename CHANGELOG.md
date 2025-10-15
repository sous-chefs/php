# PHP Cookbook CHANGELOG

This file is used to list changes made in each version of the PHP cookbook.

Standardise files with files in sous-chefs/repo-management
Standardise files with files in sous-chefs/repo-management

## 10.2.3 - *2024-11-18*

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

## 10.1.2 - *2024-11-06*

* delay `phpX.Y-fpm` service restart upon configuration update

## 10.1.1 - *2024-08-01*

* resolved cookstyle error: metadata.rb:14:20 refactor: `Chef/Correctness/SupportsMustBeFloat`

## 10.1.0 - *2024-07-31*

* Support fedora platform
* Update cicd platforms because of EOL

## 10.0.3 - *2024-07-29*

Standardise files with files in sous-chefs/repo-management

* Correct the php version for rhel9. Visible in the fpm pool

## 10.0.2 - *2024-05-23*

* Fix typos in documentation for `php_install` and `php_ini` resources

## 10.0.1 - *2024-05-23*

* Standardise files with files in sous-chefs/repo-management

## 10.0.0 - *2024-05-23*

Standardise files with files in sous-chefs/repo-management

* Convert cookbook to resource-based by replacing recipes and attributes
* Add custom resources php_install and php_ini
* Drop direct support for installation from community repos and source
* Fix failing Actions
  * Drop support for CentOS 7, Debian 10, and Amazon Linux 2
  * Add support for AlmaLinux 9, CentOS Stream 9, Rocky Linux 9, and Ubuntu 24.04
  * Exclude Amazon Linux and Ubuntu 18.04 from community install tests because
    they aren't supported by the community repos

## 9.2.10 - *2023-04-07*

Standardise files with files in sous-chefs/repo-management

## 9.2.7 - *2023-04-01*

Standardise files with files in sous-chefs/repo-management

## 9.2.6 - *2023-03-15*

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

## 9.2.5 - *2023-02-20*

Standardise files with files in sous-chefs/repo-management

## 9.2.4 - *2023-02-16*

Standardise files with files in sous-chefs/repo-management

## 9.2.3 - *2023-02-15*

Standardise files with files in sous-chefs/repo-management

## 9.2.2 - *2023-01-26*

* Misc cleanup

## 9.2.1 - *2022-12-08*

* Standardise files with files in sous-chefs/repo-management

## 9.2.0 - *2022-06-14*

* Add support for Ubuntu 22.04
* Update tested platforms
   * added: Ubuntu 22.04

## 9.1.4 - *2022-04-20*

* Standardise files with files in sous-chefs/repo-management

## 9.1.3 - *2022-02-17*

* Standardise files with files in sous-chefs/repo-management

## 9.1.2 - *2022-02-08*

* Switch to using reusable CI workflow
* Update tested platforms
   * removed: CentOS 8, Debian 9
   * added: CentOS Stream 8, Rocky / Alma 8, Debian 11

## 9.1.1 - *2022-02-08*

* Remove delivery folder

## 9.1.0 - *2021-11-13*

* Reenable community package recipe for CentOS 8
   * Bumps `yum-remi-chef` dependency to >= 5.0.1

## 9.0.0 - *2021-09-08*

* Enable `unified_mode` for Chef 17 compatibility
* Remove EOL Ubuntu 16.04 from testing
* Add missing attributes to Ubuntu community package test
* Add missing suites to GH Actions

## 8.1.2 - *2021-08-30*

* Standardise files with files in sous-chefs/repo-management

## 8.1.1 - *2021-06-01*

* Standardise files with files in sous-chefs/repo-management

## 8.1.0 - *2021-04-22*

* Add ability to use community repositories to install newer versions of PHP

## 8.0.1 (2020-11-12)

* Prevent Apache from being pulled in as a dependency on Ubuntu 20.04 (#311)

## 8.0.0 (2020-07-09)

* Drop support for:
   * Debian 8
   * Ubuntu < 16.04
   * Amazon Linux 1
* Set default PHP version to 7.2.x
* Update Ubuntu 18.04 support to source build PHP 7.2
* Update attributes for Debian 10
* Add support for Ubuntu 20.04
* Only symlink GMP on Ubuntu 16.04 to aid source builds
* Drop support for installing from source on Debian 9

## 7.2.0 (2020-06-19)

* Include extension priority on the specified format to the extension file

## 7.1.0 (2020-05-05)

* Split out resource documentation into the documentation folder
* Run cookstyle 0.75.1
* Fix dependency problem with installing php from source on ubuntu 18.04
* Simplify platform checks
* Remove unused long_description metadata from metadata.rb
* Migrated to Github Actions for testing
* Adding control of php-fpm php.ini with specific attribute

## 7.0.0 (2019-08-07)

* Drop support for Chef 13* so we don't need to require build essentials
* Sync php.ini template with php.ini-production from php-7.2.18

## 6.1.1 (2018-08-07)

* Pass in missing argument to manage_pecl_ini method when trying to remove a module

## 6.1.0 (2018-07-24)

* Allow default recipe to skip pear channel configuration

## 6.0.0 (2018-04-16)

### Breaking Change

This release removes the previous recipes in this cookbook for setting up various PEAR extensions. These should now be setup using the php_pear module directly and not done by adding various recipes / manipulating attributes

### Other Changes

* Use the build_essential resource directly so we can call this from Chef itself on Chef 14
* Add specs for additional platforms
* Move the helpers back into the resources which makes them easier to ship in Chef later
* Break out logic in the channel resource into a helper
* Add support for Amazon Linux 2

## 5.1.0 (2018-04-05)

* Don't eval the action_class
* use php pear binary property in all recipes
* Remove incorrect not_if in the php_pear resource
* More testing updates
* Initial support for Ubuntu 18.04

## 5.0.0 (2018-02-15)

* Simplify this cookbook to remove the dependency on mysql cookbook, and remove the database dependencies in the recipes and attributes. This will allow folks who are using the mysql cookbook to be able to upgrade as needed (or pin to earlier versions). As this is a big change, pin to an earlier version if you need the mysql support that was previously available in this cookbook. Future versions may contain a resource that allows for recompiling php with the necessary extensions.
* Usage of `node['php']['pear']` in the php_pear resource has been replaced with a new 'binary' property for specifying the path to the binary
* Added a new `priority` property to the php_pear resource

## 4.6.0 (2018-02-07)

* Converted the php_pear resource to a custom resource
* Moved all helper logic out of the resource and into its own helper library file
* Fix source install on Ubuntu by making sure we have xml2-config package
* Remove options that are no longer recognised by the php installer when installing from source
* Remove matchers as we no longer require them with a modern ChefDK

## 4.5.0 (2017-07-11)

* Add reinstall chefspec matcher
* Switch from maintainers files to a simple readme section
* Remove allow_call_time_pass_reference and y2k_compliance config on Debian/Ubuntu as no supported PHP version supports it
* Initial Debian 9 support

## 4.4.0 (2017-06-27)

* Add a reinstall action to php_pear
* Added additional specs for package installs on different platforms

## 4.3.0 (2017-06-27)

* Remove fallback default php attributes that were used if we were on an unsupported platform. If we don't know the platform we don't support it and we should fail until we add proper support
* Add a few attributes needed for fpm support on opensuse. This is a work in progress to get full PHP support on opensuse
* Install xml deps and avoid using xml cookbook since it's been deprecated
* Expand the php_pear testing
* Remove double logging and log the correct package name in php_pear resource
* Cleanup readme example codes, improve formatting and remove references to LWRPs as they are just resources now

## 4.2.0 (2017-05-30)

* Make sure package intalls, php-fpm, and source installs work on Amazon linux
* Avoid symlink warning in the converges
* Simplify the package install logic
* Rename the inspec test to match the suite name so it actually runs
* Test on FreeBSD 11 / Amazon Linux
* Install 5.6.30 by default on source installs

## 4.1.0 (2017-05-30)

* Remove class_eval usage and require Chef 12.7+

## 4.0.0 (2017-04-20)

* Fix pear_channel resource to not fail on Chef 12.5 and 12.6
* Remove support for RHEL 5 as it is now EOL
* Resolve Amazon Linux failures on Chef 13
* Convert fpm_pool to a custom resource
* Fix php_pear failures on Chef 13
* Remove non-functional support for Windows
* Remove redundant Ubuntu version checks in the php_pear provider
* Expand testing to test all of the resources

## 3.1.1 (2017-04-20)

* Use the cookbook attribute as the default value of pear_channel pear property to provide better platform support

## 3.1.0 (2017-04-10)

* Use multi-package installs on supported platform_family(rhel debian suse amazon)
* Use a SPDX standardized license string in the metadata
* Update specs for the new Fauxhai data

## 3.0.0 (2017-03-27)

* Converted pear_channel LWRP into custom resource
* Removed use of pear node attribute from pear_channel resource
* Fix cookstyle issue with missing line on metadata.rb
* Clean up kitchen.dokken.yml file to eliminate duplication of testing suites.
* Eliminate duplicated resource from test cookbook that is in the default recipe.
* Rename php-test to standard cookbook testing cookbook of "test"
* Remove EOL ubuntu platform logic

**NOTE** Windows package installation is currently broken.

## 2.2.1 (2017-02-21)

* Fix double definition of ['php']['packages'] for rhel.

## 2.2.0 (2016-12-12)

* Use multipackage for installs to speed up chef runs
* Use all CPUs when building from source
* Remove need for apt/yum in testing
* Add opensuse to the metadata
* Migrate to inspec for integration testing

## 2.1.1 (2016-09-15)

* Fix recompile un-pack php creates
* Resolve cookstyle warnings

## 2.1.0 (2016-09-14)

* Fix source php version check
* Require Chef 12.1 not 12.0

## 2.0.0 (2016-09-07)

* Require Chef 12+
* Remove the dependency on the Windows cookbook which isn't necessary with Chef 12+

## 1.10.1 (2016-08-30)

* [fix] bug fixes related with Ubuntu 16.04 and PHP 7 support
* adding validator to listen attribute
* Fix node.foo.bar warnings

## v1.10.0 (2016-07-27)

* PR #167 Preventing user specified pool of www from being deleted at the end of the chef run on the first install
* PR #122 Add recipe for php module_imap
* PR #172 Fix uninstall action for resource php_fpm_pool

## v1.9.0 (2016-05-12)

Special thanks to @ThatGerber for getting the PR for this release together

* Added support for Ubuntu 16.04 and PHP 7
* Added support for different listen user/groups with FPM
* Cleaned up resource notification in the pear_channel provider to simplify code
* Fixed Ubuntu 14.04+ not being able to find the GMP library

## v1.8.0 (2016-02-25)

* Bumped the source install default version from 5.5.9 to 5.6.13
* Added a chefignore file to limit the files uploaded to the Chef server
* Added source_url and issues_url to the metadata.rb
* Added additional Chefspec matchers
* Added a Chef standard rubocop.yml file and resolved warnings
* Added serverspec for integration testing
* Remove legacy cloud Test Kitchen configs
* Added testing in Travis CI with kitchen-docker
* Added additional test suites to the Test Kitchen config
* Updated contributing and testing documentation
* Updated testing gem dependencies to the latest
* Added maintainers.md and maintainers.toml files
* Remove gitter chat from the readme
* Add cookbook version badge to the readme
* Added Fedora as a supported platform in the readme
* Add missing cookbook dependencies to the readme

## v1.7.2 (2015-8-24)

* Correct spelling in fpm_pool_start_servers (was servres)

## v1.7.1 (2015-8-17)

* Correct permissions on ext_conf_dir folder (644 -> 755)

## v1.7.0 (2015-7-31)

* NOTICE - This version changes the way the ['php']['directives'] is placed into configuration files. Quotes are no longer automatically placed around these aditional directives. Please take care when rolling out this version.
* Allow additional PHP FPM config
* Add recipe to recompile PHP from source
* Move source dependencies to attributes file
* Misc bug fixes

## v1.6.0 (2015-7-6)

* Added ChefSpec matchers
* Added basic PHP-FPM Support (Pre-Release)
* Added support for FreeBSD
* Updated cookbook to use MySQL 6.0 cookbook
* Update cookbook to use php5enmod on supported platforms
* Allow users to override php-mysql package

## v1.5.0 (2014-10-06)

* Adding package_options attribute, utilizing in package resource

## v1.4.6 (2014-03-19)

* [COOK-4436] - Test this cookbook, not yum. Also test Fedora 20.
* [COOK-4427] - Add oracle as supported operating system

## v1.4.4 (2014-03-12)

* [COOK-4393] - Fix convergence bug in source install

## v1.4.2 (2014-02-27)

[COOK-4300] - Simplified and fixed pear/pecl logic. [Fixes #56 / #57]

## v1.4.0 (2014-02-27)

[COOK-3639] - Allow users to specify php.ini source template

## v1.3.14 (2014-02-21)

### Bug

* [COOK-4186] - Upgrade_package concatenates an empty version string when version is not set or is empty.

## v1.3.12 (2014-01-28)

Fix github issue 'Cannot find a resource for preferred_state'

## v1.3.10

Fixing my stove

## v1.3.8

Version bump to ensure artifact sanity

## v1.3.6

Version bump for toolchain

## v1.3.4

Adding platform_family check to include_recipe in source.rb

## v1.3.2

Fixing style cops. Updating test harness

## v1.3.0

### Bug

* [COOK-3479] - Added Windows support to PHP
* [COOK-2909] - Warnings about Chef::Exceptions::ShellCommandFailed is deprecated

## v1.2.6

### Bug

* [COOK-3628] - Fix PHP download URL
* [COOK-3568] - Fix Test Kitchen tests
* [COOK-3402] - When the `ext_dir` setting is present, configure php properly for the source recipe
* [COOK-2926] - Fix pear package detection when installing specific version

## v1.2.4

### Improvement

* [COOK-3047] - Sort directives in `php.ini`
* [COOK-2928] - Abstract `php.ini` directives into variables

### Bug

* [COOK-2378] - Fix `php_pear` for libevent

## v1.2.2

### Bug

* [COOK-3050]: `lib_dir` declared in wrong place for redhat
* [COOK-3102]: remove fileinfo recipe from php cookbook

### Improvement

* [COOK-3101]: use a method to abstract range of "el 5" versions in php recipes

## v1.2.0

### Improvement

* [COOK-2516]: Better support for SUSE distribution for php cookbook
* [COOK-3035]: update php::source to install 5.4.15 by default

### Bug

* [COOK-2463]: PHP PEAR Provider Installs Most Recent Version, Without Respect to Preferred State
* [COOK-2514]: php_pear: does not handle more exotic version strings

## v1.1.8

* [COOK-1998] - Enable override of PHP packages in attributes

## v1.1.6

* [COOK-2324] - adds Oracle linux support

## v1.1.4

* [COOK-2106] - `php_pear` cannot find available packages

## v1.1.2

* [COOK-1803] - use better regexp to match package name
* [COOK-1926] - support Amazon linux

## v1.1.0

* [COOK-543] - php.ini template should be configurable
* [COOK-1067] - support for PECL zend extensions
* [COOK-1193] - update package names for EPEL 6
* [COOK-1348] - rescue Mixlib::ShellOut::ShellCommandFailed (chef 0.10.10)
* [COOK-1465] - fix pear extension template

## v1.0.2

* [COOK-993] Add mhash-devel to centos php source libs
* [COOK-989] - bump version of php to 5.3.10
* Also download the .tar.gz instead of .tar.bz2 as bzip2 may not be in the base OS (e.g., CentOS 6 minimal)
