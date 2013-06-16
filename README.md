chef-php
========

Installs and configures PHP 5.3 and the PEAR package management system via OpsCode Chef.  Also includes LWRPs for managing PEAR (and PECL) packages along with PECL channels and PHP-FPM profiles.

You can clone it and import it to Chef as

    cd cookbooks
    git clone git://github.com/priestjim/chef-php.git php
    knife cookbook upload php

Requirements
============

This cookbook requires the following cookbooks to be present and installed:

* apache2 (for the Apache mod_php module)
* chef-yumrepo from https://github.com/priestjim/chef-yumrepo for the Atomic repository in CentOS

To build PHP from source you will also need:

* build-essential
* xml
* mysql

Supported Operating Systems
===========================

This cookbook supports the following Linux distributions:

* Ubuntu >= 12.04
* Debian >= 6.0
* CentOS >= 6.0
* RedHat >= 6.0

It also supports **Chef 10.14** and higher

Attributes
==========

The file contains the following attribute types:

* platform specific locations and settings.
* source installation settings
* ini configuration settings
* fpm-specific settings

Resource/Provider
=================

This cookbook includes LWRPs for managing:

* PEAR channels
* PEAR/PECL packages
* PHP-FPM instances

## `php_pear_channel`

[PEAR Channels](http://pear.php.net/manual/en/guide.users.commandline.channels.php) are alternative sources for PEAR packages.  This LWRP provides and easy way to manage these channels.

### Actions

- `discover`: Initialize a channel from its server.
- `add`: Add a channel to the channel list, usually only used to add private channels.  Public channels are usually added using the `:discover` action
- `update`: Update an existing channel
- `remove`: Remove a channel from the List

### Parameters

- `channel_name`: name attribute. The name of the channel to discover
- `channel_xml`: the channel.xml file of the channel you are adding

### Example
    
    # discover the horde channel
    php_pear_channel "pear.horde.org" do
      action :discover
    end
    
    # download xml then add the symfony channel
    remote_file "#{Chef::Config['file_cache_path']}/symfony-channel.xml" do
      source "http://pear.symfony-project.com/channel.xml"
      mode 0644
    end
    php_pear_channel "symfony" do
      channel_xml "#{Chef::Config['file_cache_path']}/symfony-channel.xml"
      action :add
    end
    
    # update the main pear channel
    php_pear_channel 'pear.php.net' do
      action :update
    end
    
    # update the main pecl channel
    php_pear_channel 'pecl.php.net' do
      action :update
    end
    

## `php_pear`

[PEAR](http://pear.php.net/) is a framework and distribution system for reusable PHP components. [PECL](http://pecl.php.net/) is a repository for PHP Extensions. PECL contains C extensions for compiling into PHP. As C programs, PECL extensions run more efficiently than PEAR packages. PEARs and PECLs use the same packaging and distribution system.  As such this LWRP is clever enough to abstract away the small differences and can be used for managing either.  This LWRP also creates the proper module .ini file for each PECL extension at the correct location for each supported platform.

### Actions

- `install`: Install a pear package - if version is provided, install that specific version
- `upgrade`: Upgrade a pear package - if version is provided, upgrade to that specific version
- `remove`: Remove a pear package
- `purge`: Purge a pear package (this usually entails removing configuration files as well as the package itself).  With pear packages this behaves the same as `:remove`

### Parameters

- `package_name`: name attribute. The name of the pear package to install
- `version`: the version of the pear package to install/upgrade.  If no version is given latest is assumed.
- `preferred_state`: PEAR by default installs stable packages only, this allows you to install pear packages in a devel, alpha or beta state
- `directives`: extra extension directives (settings) for a pecl. on most platforms these usually get rendered into the extension's .ini file
- `options`: Add additional options to the underlying pear package command


### Example

    # upgrade a pear
    php_pear "XML_RPC" do
      action :upgrade
    end
    
    
    # install a specific version
    php_pear "XML_RPC" do
      version "1.5.4"
      action :install
    end
    
    
    # install the mongodb pecl
    php_pear "mongo" do
      action :install
    end
    
    
    # install apc pecl with directives
    php_pear "apc" do
      action :install
      directives(:shm_size => 128, :enable_cli => 1)
    end
    
    
    # install the beta version of Horde_Url 
    # from the horde channel
    hc = php_pear_channel "pear.horde.org" do
      action :discover
    end
    php_pear "Horde_Url" do
      preferred_state "beta"
      channel hc.channel_name
      action :install
    end
    
    
    # install the YAML pear from the symfony project
    sc = php_pear_channel "pear.symfony-project.com" do
      action :discover
    end
    php_pear "YAML" do
      channel sc.channel_name
      action :install
    end

## `php_fpm`

PHP-FPM is a relatively new extension to PHP that actually embeds a FastCGI process manager right inside the PHP codebase. It runs independently of Apache or NGINX and supports both Apache's `mod_fcgi` and NGINX's `fastcgi` modules. You can easily create farms of PHP application servers using PHP-FPM as the middleware to your web frontend (i.e. NGINX and PHP-FPM work pretty well).

### Actions

* `add`: Adds a PHP-FPM instance and restarts the service
* `remove`: Removes the PHP-FPM instance profile from the PHP-FPM pool and restarts the PHP-FPM service

### Parameters

* `name`: name attribute. Defines the PHP-FPM's pool name and actual .conf filename
* `user`: System user the pool runs as.
* `group`: System group the pool runs as.
* `socket`: Set to `true` to enable communication via a UNIX socket instead of IP. Only useful if you run PHP-FPM on the same system with the web server or over a shared filesystem (i.e. NFS)
* `socket_path`: The UNIX socket filename
* `socket_user`: The UNIX socket file owner
* `socket_group`: The UNIX socket file group
* `socket_perms`: The UNIX socket file permissions. Set it to "0666" if running the web server under a different user for the web server to be able to write to it.
* `ip_address`: IF you are not using a UNIX socket, bind the FPM instance to a specific IP address. Use 0.0.0.0 to bind to all interfaces
* `port`: TCP port to bind to, to accept requests
* `ip_whitelist`: An array of IP addresses from which we can accept requests. Useful only for IP-based communication
* `max_children`: Maximum number of concurrent running pool children
* `start_servers`: Initial number of started pool servers
* `min_spare_servers`: Minimum number of idling servers. Must be equal to or larger than start_servers.
* `max_spare_servers`: Maximum number of idling servers
* `max_requests`: Maximum number of requests a pool child has received after being recycled. Useful for combating memory leaks that can't be fixed in any other way
* `backlog`: Maximum number of pending requests a pool can have waiting
* `status_url`: A URL to query the status of the pool
* `ping_url`: A URL to ping for health monitoring
* `ping_response`: The response expected from pinging healthy instance
* `log_filename`: A log filename for pool request logging
* `log_format`: The format in which the pool will be logging to the request log
* `slow_filename`: A file for recording long-taking requests
* `slow_timeout`: The slow request threshold
* `valid_extensions`: A number of extensions that are considered safe for processing
* `terminate_timeout`: A timeout after which the pool master process will terminate the child. Must be equal or large to the longest expected maximum execution time
* `initial_directory`: A directory to change to before start accepting request
* `flag_overrides`: A hash of PHP flags that will be overridden in the manner of Apache's `php_flag` and `php_admin_flag`
* `value_overrides`: A hash of PHP values that will be overridden in the manner of Apache's `php_value` and `php_admin_value`
* `env_overrides`: A hash of environment variables that will be overridden embedded in the pools environment variable set

### Example

    # Define a pool for PHPMyAdmin
    php_fpm 'phpmyadmin' do
      action :add
      user 'phpmyadmin'
      group 'phpmyadmin'
      socket true
      socket_path '/tmp/phpmyadmin.sock'
      socket_perms "0666"
      start_servers 2
      min_spare_servers 2
      max_spare_servers 8
      max_children 8
      terminate_timeout (node['php']['ini_settings']['max_execution_time'].to_i + 20)
      value_overrides({ 
        :error_log => "#{node['php']['fpm_log_dir']}/phpmyadmin.log"
      })
    end

---

Recipes
=======

## `default`

Include the default recipe in a run list, to get `php`.

## `package`

This recipe installs PHP from packages.

## `fpm`

This recipe installs and configures the PHP FastCGI Process Manager but without any pools. To define an application pool please use the php_fpm LWRP.

## `module_*`

This recipe installs various PHP modules via the appropriate package commands. *module_common* will install a common set of PHP modules needed for most web applications (such as Joomla or Wordpress).

Usage
=====

Simply include the `php` recipe where ever you would like php installed.  To install from source override the `node['php']['install_method']` - with in a role:

    name "php"
    description "Install php from source"
    override_attributes(
      "php" => {
        "install_method" => "source"
      }
    )
    run_list(
      "recipe[php]"
    )

---

License and Author
==================

* Author:: Panagiotis Papadomitsos (<pj@ezgr.net>)
* Author:: Seth Chisamore (<schisamo@opscode.com>)
* Author:: Joshua Timberman (<joshua@opscode.com>)

Modifications Copyright:: 2012, Panagiotis Papadomitsos

Original Copyright:: 2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
