# Agent Notes

## PHP request-order defaults

The owner requested the defaults shipped by Red Hat packages for issue #235.
Official default-stream php-common packages in Red Hat UBI 8, 9 and 10 and
CentOS 7, 8, Stream 9 and Stream 10 set `request_order` to `GP`. The CentOS 8
package was inspected from the official CentOS vault without executing its
x86_64 binary. Red Hat 7 could not be independently verified, so its existing
behaviour is preserved. The `directives` property must continue to override the
template's default by appearing later in the generated file.

The existing Kitchen files contain different platform lists: `kitchen.yml`
defines the Vagrant matrix, `kitchen.dokken.yml` adds images, and
`kitchen.exec.yml` has macOS and Windows entries that are not declared in
`metadata.rb`. The default package helper has no SUSE branch even though an
openSUSE Dokken image is listed. These differences are retained; they do not
prove support for those extra entries. The CI `default` suite runs on CentOS
Stream 9 and retains the pre-existing resource suites and matrix.

## Policyfile Integration Limits

The `resource-community` suite exercises external community package repositories, not only this cookbook's resources. Keep the suite matrix aligned with package availability:

* Fedora is excluded from `resource-community` because the Remi Fedora repository does not provide the `php8.2`, `php8.2-cgi`, `php8.2-cli`, `php8.2-dev`, and `php8.2-xml` package set used by the test recipe.
* Ubuntu 20.04 is excluded from `resource-community` because the Ondrej PHP PPA no longer provides the PHP 8.2 package set for focal.
* EL9 `resource-community` uses the legacy `yum-remi-chef::remi` recipe, which still configures only older Remi GPG keys. The test recipe adds the current Remi signing key set so package verification can follow upstream key rotation.
* Fedora `resource` and `resource-peclchannel` remain supported. `php_pear` installs explicit compiler packages on Fedora instead of using `build_essential`, because Dokken Fedora images can request an unavailable host-matching `kernel-devel` package.
* Fedora skips the PECL `sync` fixture because `sync` 1.1.3 does not compile against Fedora latest's PHP 8.5 headers. Keep the channel and PEAR package checks enabled there.
