# Upgrading

The `package` and `ini` recipes have been removed and replaced with custom resources:

- package --> php_install
- ini     --> php_ini

## Attributes

Attributes have been converted to resource properties; default values are set in helpers. Please see the documentation for all properties and their defaults.

The following table lists the resources and properties that attributes have been moved to:

| Attribute             | Resource                                     | Property Name (if different) |
| ----------------------| -------------------------------------------- | ---------------------------- |
| ['bin']               | Removed                                      |                              |
| ['checksum']          | Removed                                      |                              |
| ['conf_dir']          | php_ini, php_install, php_pear               |                              |
| ['configure_options'] | Removed                                      |                              |
| ['directives']        | php_fpm_pool, php_ini, php_install, php_pear |                              |
| ['disable_mod']       | php_pear                                     |                              |
| ['enable_mod']        | php_pear                                     |                              |
| ['ext_conf_dir']      | php_pear                                     |                              |
| ['ext_dir']           | php_fpm_pool, php_ini, php_install           |                              |
| ['fpm_conf_dir']      | php_fpm_pool                                 |                              |
| ['fpm_default_conf']  | php_fpm_pool                                 | :default_conf                |
| ['fpm_group']         | php_fpm_pool                                 | :group                       |
| ['fpm_ini_control']   | php_fpm_pool                                 |                              |
| ['fpm_listen_group']  | php_fpm_pool                                 | :listen_group                |
| ['fpm_listen_user']   | php_fpm_pool                                 | :listen_user                 |
| ['fpm_package']       | php_fpm_pool                                 |                              |
| ['fpm_pool_dir']      | php_fpm_pool                                 | :pool_dir                    |
| ['fpm_service']       | php_fpm_pool                                 | :service                     |
| ['fpm_socket']        | php_fpm_pool                                 | :listen                      |
| ['fpm_user']          | php_fpm_pool                                 | :user                        |
| ['ini']['cookbook']   | php_fpm_pool, php_ini, php_install           | :ini_cookbook                |
| ['ini']['template']   | php_fpm_pool, php_ini, php_install           | :ini_template                |
| ['install_method']    | Removed                                      |                              |
| ['packages']          | php_install                                  |                              |
| ['pear']              | Removed                                      |                              |
| ['pear_channels']     | Removed                                      |                              |
| ['pear_setup']        | Removed                                      |                              |
| ['pecl']              | php_pear                                     |                              |
| ['prefix_dir']        | Removed                                      |                              |
| ['src_deps']          | Removed                                      |                              |
| ['src_recompile']     | Removed                                      |                              |
| ['url']               | Removed                                      |                              |
| ['version']           | Helper                                       | php_version                  |

Attributes specific to recipes or installing from source were removed.

## Package Install

Installing from package managers can now be done through the `php_install` resource.

```ruby
# Old Style
include_recipe 'php::default'
```

```ruby
# New Style
php_install 'php' do
  action :install
end
```

## Community Install

Installing from community repos is no longer built in to the cookbook. The `php_install` resource can be configured to help in installing from community repos. See [`test/cookbooks/test/recipes/community.rb`](https://github.com/sous-chefs/php/tree/main/test/cookbooks/test/recipes/community.rb) for an example of fetching and installing from community repos.

## Source Install

Installing from source is no longer built in to the cookbook. Users should manage installation from source on their own. The original recipe can be referenced [here](https://github.com/sous-chefs/php/blob/9.2.16/recipes/source.rb) to help with the switch.

## .ini Configuration

Configuring PHP and FPM can now be done through the `php_ini` resource.

```ruby
# Old Style
include_recipe 'php::ini'
```

```ruby
# New Style
php_ini 'php' do
  action :add
end
```

A `.ini` file can also be removed using the `php_ini` resource.

```ruby
# New Style
php_ini 'php' do
  action :remove
end
```

The `node['php']['fpm_ini_control']` attribute has been moved to a property of the `php_fpm_pool` resource.

```ruby
# Old Style
node['php']['fpm_ini_control'] = true
include_recipe 'php::ini'
```

```ruby
# New Style
php_fpm_pool 'fpm_pool' do
  fpm_ini_control true
  action :install
end
```
