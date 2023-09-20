# `php_install`

Adds a `php.ini` to the appropriate location.

## Actions

- `:add`: Add a `php.ini` file (default)
- `:remove`: Remove a `php.ini` file

## Properties

| Name                | Type             | Default                                               | Description                                                 |
| ------------------- | ---------------- | ----------------------------------------------------- | ----------------------------------------------------------- |
| `conf_dir`          | `String`         | Platform-specific - see `libraries/helpers.rb         | Directory to place the `php.ini` file under                 |
| `ini_template       | `String`         | `php.ini.erb` (see `templates/<distro>/php.ini.rb`)   | Template to use to create the `php.ini` file                |
| `ini_cookbook`      | `String`         | `php` (this cookbook)                                 | Cookbook where the template is located                      |
| `directives`        | `Hash`           | `{}`                                                  | Directive-value pairs to add to the `php.ini` file          |
| `ext_dir`           | `String`         | Platform-specific - see `libraries/helpers.rb`        | Directory in which the loadable extensions (modules) reside |

## Examples

Add a `php.ini` file to the default location for your platform

```ruby
php_ini 'ini' do
  action :add
end
```

Add a `php.ini` file to the `/etc/php-fpm.d` directory

```ruby
php_ini 'fpm.d' do
  conf_dir '/etc/php-fpm.d'
  action :add
end
```

Remove a `php.ini` file from the `/etc/php-fpm.d` directory

```ruby
php_ini 'fpm.d' do
  conf_dir '/etc/php-fpm.d'
  action :remove
end
```
