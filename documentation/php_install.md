# `php_install`

By default, installs the `php` packages appropriate for your platform and adds a `php.ini` to the default location for that platform.

## Actions

- `:install`: Installs PHP packages (default)

## Properties

| Name                | Type             | Default                                               | Description                                                 |
| ------------------- | ---------------- | ----------------------------------------------------- | ----------------------------------------------------------- |
| `packages`          | `String`         | Platform-specific - see `libraries/helpers.rb`        | Packages to install                                         |
| `options`           | `[String, Array] |                                                       | Installation options (see Chef `package` resource)          |
| `conf_dir`          | `String`         | Platform-specific - see `libraries/helpers.rb         | Directory to place the `php.ini` file under                 |
| `ini_template       | `String`         | `php.ini.erb` (see `templates/<distro>/php.ini.rb`)   | Template to use to create the `php.ini` file                |
| `ini_cookbook`      | `String`         | `php` (this cookbook)                                 | Cookbook where the template is located                      |
| `directives`        | `Hash`           | `{}`                                                  | Directive-value pairs to add to the `php.ini` file          |
| `ext_dir`           | `String`         | Platform-specific - see `libraries/helpers.rb`        | Directory in which the loadable extensions (modules) reside |

## Examples

Install the default packages for your platform

```ruby
php_install 'php' do
  action :install
end
```

See [`test/cookbooks/test/recipes/community.rb`](https://github.com/sous-chefs/php/tree/main/test/cookbooks/test/recipes/community.rb) for an example for installing from a community repository.
