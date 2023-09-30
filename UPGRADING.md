# Upgrading

The `default` and `ini` recipes have been removed and replaced with custom resources:

- default --> php_install
- ini     --> php_ini

## Attributes

Attributes have been converted to resource properties; default values are set in helpers. Please see the documentation for all properties.

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
