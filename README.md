# php Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/php.svg)](https://supermarket.chef.io/cookbooks/php)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/php/master.svg)](https://circleci.com/gh/sous-chefs/php)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

The `php` cookbook installs and configures PHP and the PEAR package management system. Also includes resources for managing PEAR (and PECL) packages, PECL channels, and PHP-FPM pools.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- Ubuntu 18.04 / 20.04 / 22.04
- Debian 10 / 11
- CentOS 7+ (incl. Alma & Rocky)
- Amazon Linux 2023

### Chef

- Chef 15.3+

## Resources

This cookbook includes resources for managing:

<!-- markdown-link-check-disable-next-line -->
- [php_ini](https://github.com/sous-chefs/php/tree/main/documentation/php_ini.md)
<!-- markdown-link-check-disable-next-line -->
- [php_install](https://github.com/sous-chefs/php/tree/main/documentation/php_install.md)
- [php_pear](https://github.com/sous-chefs/php/tree/main/documentation/php_pear.md)
- [php_pear_channel](https://github.com/sous-chefs/php/tree/main/documentation/php_pear_channel.md)
- [php_fpm_pool](https://github.com/sous-chefs/php/tree/main/documentation/php_fpm_pool.md)

## Usage

<!-- markdown-link-check-disable-next-line -->
Simply use the `php_install` resource wherever you would like PHP installed from a package. By default, it will install from the platform's package manager (see [`libraries/helpers.rb`](https://github.com/sous-chefs/php/tree/main/libraries/helpers.rb) to see the default packages list for each platoform).

Please see [`test/cookbooks/test/recipes/community.rb`](https://github.com/sous-chefs/php/tree/main/test/cookbooks/test/recipes/community.rb) for an example of using the `php_install` resource to install the desired version of PHP & its supporting packages from a community repository, and please refer to the documentation on these community repositories:

- RHEL/CentOS - [Remi’s RPM repository](https://rpms.remirepo.net)
- Ubuntu - [Ondřej Surý PPA](https://launchpad.net/~ondrej/+archive/ubuntu/php)
- Debian - [Sury repo](https://deb.sury.org/)

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
