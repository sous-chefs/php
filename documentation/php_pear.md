# `php_pear`

[PEAR](http://pear.php.net/) is a framework and distribution system for reusable PHP components. [PECL](http://pecl.php.net/) is a repository for PHP Extensions. PECL contains C extensions for compiling into PHP. As C programs, PECL extensions run more efficiently than PEAR packages. PEARs and PECLs use the same packaging and distribution system. As such this resource is clever enough to abstract away the small differences and can be used for managing either. This resource also creates the proper module .ini file for each PECL extension at the correct location for each supported platform.

## Actions

- `:install`: Install a pear package - if version is provided, install that specific version
- `:upgrade`: Upgrade a pear package - if version is provided, upgrade to that specific version
- `:remove`: Remove a pear package
- `:reinstall`: Force install of the package even if the same version is already installed. Note: This will converge on every Chef run and is probably not what you want.
- `:purge`: An alias for remove as the two behave the same in pear

## Properties

| Name              | Type     | Default  | Descrption                                                                                                                    |
| ----------------- | -------- | -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `package_name`    | `String` |          | The name of the pear package to install                                                                                       |
| `version`         | `String` |          | the version of the pear package to install/upgrade. If no version is given latest is assumed.                                 |
| `channel`         | `String` |          |                                                                                                                               |
| `options`         | `String` |          | Add additional options to the underlying pear package command                                                                 |
| `directives`      | `Hash`   | `{}`     | extra extension directives (settings) for a pecl. on most platforms these usually get rendered into the extension's .ini file |
| `zend_extensions` | `Array`  | `[]`     | PEAR by default installs stable packages only, this allows you to install pear packages in a devel, alpha or beta state       |
| `preferred_state` | `String` | `stable` | Package type to install                                                                                                       |
| `binary`          | `String` |          | The pear binary to use, by default pear, can be overridden if the binary is not called pear, e.g. pear7                       |

## Examples

```ruby
# upgrade a pear
php_pear 'XML_RPC' do
  action :upgrade
end

# install a specific version
php_pear 'XML_RPC' do
  version '1.5.4'
  action :install
end

# install the mongodb pecl
php_pear 'Install mongo but use a different resource name' do
  package_name 'mongo'
  action :install
end

# install the xdebug pecl
php_pear 'xdebug' do
  # Specify that xdebug.so must be loaded as a zend extension
  zend_extensions ['xdebug.so']
  action :install
end

# install apc pecl with directives
php_pear 'apc' do
  action :install
  directives(shm_size: 128, enable_cli: 1)
end

# install using the pear-7 binary
php_pear 'apc' do
  action :install
  binary 'pear7'
end

# install sync using the pecl binary
php_pear 'sync' do
  version '1.1.1'
  binary 'pecl'
end

# install sync using the pecl channel
php_pear 'sync' do
  version '1.1.1'
  channel 'pecl.php.net'
end

# install the beta version of Horde_Url
# from the horde channel
hc = php_pear_channel 'pear.horde.org' do
  action :discover
end

php_pear 'Horde_Url' do
  preferred_state 'beta'
  channel hc.channel_name
  action :install
end

# install the YAML pear from the symfony project
sc = php_pear_channel 'pear.symfony-project.com' do
  action :discover
end

php_pear 'YAML' do
  channel sc.channel_name
  action :install
end
```
