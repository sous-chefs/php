# Migration guide

The cookbook already exposes its PHP installation and configuration through custom resources. Use
`php_install` to install packages and configure `php.ini`, `php_ini` to manage an individual
configuration, and `php_fpm_pool`, `php_pear` and `php_pear_channel` for their respective services.
See the [test recipes](test/cookbooks/test/recipes/) for examples.

For CentOS 7–10 and Red Hat Enterprise Linux 8–10, the default generated `php.ini` now sets
`request_order` to `GP`, matching verified distribution packages. This excludes cookies from
`$_REQUEST`. Applications that depend on cookies in `$_REQUEST` can explicitly retain them:

```ruby
php_ini 'default' do
  directives 'request_order' => 'GPC'
end
```

The same `directives` property is available on `php_install` and `php_fpm_pool` when they manage
their PHP configuration. Caller-provided directives take precedence over template defaults.
Red Hat Enterprise Linux 7 retains the previous behaviour because its vendor package default was
not independently verified.
