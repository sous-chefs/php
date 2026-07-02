# `php_install`

By default, installs the `php` packages appropriate for your platform and adds a `php.ini` to the default location for that platform.

## Actions

- `:install`: Installs PHP packages (default)

## Properties

| Name           | Type              | Default                                             |
| -------------- | ----------------- | --------------------------------------------------- |
| -------------- | ----------------- | --------------------------------------------------- |
| `packages`     | `String`          | Platform-specific - see `libraries/helpers.rb`      |
| `options`      | `[String, Array]` |                                                     |
| `conf_dir`     | `String`          | Platform-specific - see `libraries/helpers.rb`      |
| `ini_template` | `String`          | `php.ini.erb` (see `templates/<distro>/php.ini.rb`) |
| `ini_cookbook` | `String`          | `php` (this cookbook)                               |
| `directives`   | `Hash`            | `{}`                                                |
| `ext_dir`      | `String`          | Platform-specific - see `libraries/helpers.rb`      |

## Examples

Install the default packages for your platform

```ruby
php_install 'php' do
  action :install
end
```

See [`test/cookbooks/test/recipes/community.rb`](https://github.com/sous-chefs/php/tree/main/test/cookbooks/test/recipes/community.rb) for an example for installing from a community repository.
