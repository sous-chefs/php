# php Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/php.svg)](https://supermarket.chef.io/cookbooks/php)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/php/master.svg)](https://circleci.com/gh/sous-chefs/php)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

It installs and configures PHP and the PEAR package management system. Also includes resources for managing PEAR (and PECL) packages, PECL channels, and PHP-FPM pools.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- Debian, Ubuntu
- CentOS, Red Hat, Oracle, Scientific, Amazon Linux
- Fedora

### Chef

- Chef 15.3+

## Attributes

- `node['php']['install_method']` = method to install php with, default `package`.
- `node['php']['directives']` = Hash of directives and values to append to `php.ini`, default `{}`.
- `node['php']['pear_setup']` = Boolean value to determine whether to set up pear repositories. Default: `true`
- `node['php']['pear_channels']` = List of external pear channels to add if `node['php']['pear_setup']` is true. Default: `['pear.php.net', 'pecl.php.net']`

The file also contains the following attribute types:

- platform specific locations and settings.
- source installation settings

## Resources

This cookbook includes resources for managing:

- [php_pear](https://github.com/sous-chefs/php/tree/master/documentation/php_pear.md)
- [php_pear_channel](https://github.com/sous-chefs/php/tree/master/documentation/php_pear_channel.md)
- [php_fpm_pool](https://github.com/sous-chefs/php/tree/master/documentation/php_fpm_pool.md)

## Recipes

### default

Include the default recipe in a run list, to get `php`. By default `php` is installed from packages but this can be changed by using the `install_method` attribute.

### package

This recipe installs PHP from packages.

### community_package

This recipe installs PHP from one of two available community package repositories, depending on platform family. This provides the ability to install PHP versions that are no provided by the official distro repositories.

Set `node['php']['install_method'] = 'community_package'` to use these repositories.

Please see `test/cookbooks/test/recipes/community.rb` for an example of how to use attributes to install the desired version of PHP & its supporting packages, and please refer to the documentation on these community repositories:

- CentOS - [Remi’s RPM repository](https://rpms.remirepo.net)
- Ubuntu - [Ondřej Surý PPA](https://launchpad.net/~ondrej/+archive/ubuntu/php)
- Debian - [Sury repo](https://deb.sury.org/)

### source

This recipe installs PHP from source.

*Note:* Debian 9 is not supported for building from source.

## Usage

Simply include the `php` recipe where ever you would like php installed. To install from source override the `node['php']['install_method']` attribute within a role or wrapper cookbook:

### Role example

```ruby
name 'php'
description 'Install php from source'
override_attributes(
  'php' => {
    'install_method' => 'source',
  }
)
run_list(
  'recipe[php]'
)
```

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
