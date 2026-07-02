# Agent Notes

## Policyfile Integration Limits

The `resource-community` suite exercises external community package repositories, not only this cookbook's resources. Keep the suite matrix aligned with package availability:

* Fedora is excluded from `resource-community` because the Remi Fedora repository does not provide the `php8.2`, `php8.2-cgi`, `php8.2-cli`, `php8.2-dev`, and `php8.2-xml` package set used by the test recipe.
* Ubuntu 20.04 is excluded from `resource-community` because the Ondrej PHP PPA no longer provides the PHP 8.2 package set for focal.
* EL9 `resource-community` uses the legacy `yum-remi-chef::remi` recipe, which still configures only older Remi GPG keys. The test recipe adds the current Remi signing key set so package verification can follow upstream key rotation.
* Fedora `resource` and `resource-peclchannel` remain supported. `php_pear` installs explicit compiler packages on Fedora instead of using `build_essential`, because Dokken Fedora images can request an unavailable host-matching `kernel-devel` package.
* Fedora skips the PECL `sync` fixture because `sync` 1.1.3 does not compile against Fedora latest's PHP 8.5 headers. Keep the channel and PEAR package checks enabled there.
