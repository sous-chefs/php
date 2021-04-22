# `php_fpm_pool`

Installs the `php-fpm` package appropriate for your distro (if using packages) and configures a FPM pool for you. Currently only supported in Debian-family operating systems and CentOS 7 (or at least tested with such, YMMV if you are using source).

Please consider FPM functionally pre-release, and test it thoroughly in your environment before using it in production
<!-- markdown-link-check-disable -->
More info: <https://www.php.net/manual/en/install.fpm.php>

## Actions

- `:install`: Installs the FPM pool (default).
- `:uninstall`: Removes the FPM pool.

## Properties

| Name                | Type     | Default                              | Descrption                                                                            |
| ------------------- | -------- | ------------------------------------ | ------------------------------------------------------------------------------------- |
| `pool_name`         | `String` | The name of the FPM pool             |                                                                                       |
| `listen`            | `String` | Default: `/var/run/php5-fpm.sock`    | The listen address                                                                    |
| `user`              |          | The webserver user for your distro.  | The user to run the FPM under                                                         |
| `group`             |          | The webserver group for your distro. | The group to run the FPM under                                                        |
| `process_manager`   |          | `dynamic`                            | Process manager to use - see <https://www.php.net/manual/en/install.fpm.configuration.php> |
| `max_children`      |          | `5`                                  | Max children to scale to                                                              |
| `start_servers`     |          | `2`                                  | Number of servers to start the pool with                                              |
| `min_spare_servers` |          | `1`                                  | Minimum number of servers to have as spares                                           |
| `max_spare_servers` |          | `3`                                  | Maximum number of servers to have as spares                                           |
| `chdir`             |          | `/`                                  | The startup working directory of the pool                                             |
| `additional_config` |          | `{}`                                 | Additional parameters in JSON                                                         |

## Examples

Install a FPM pool named default

```ruby
php_fpm_pool 'default' do
  action :install
end
```
