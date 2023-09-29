# `php_fpm_pool`

Installs the `php-fpm` package appropriate for your platform and configures a FPM pool for you. Currently only supported in Debian-family operating systems and CentOS 7 (or at least tested with such).

Please consider FPM functionally pre-release, and test it thoroughly in your environment before using it in production
<!-- markdown-link-check-disable -->
More info: <https://www.php.net/manual/en/install.fpm.php>

## Actions

- `:install`: Installs the FPM pool (default).
- `:uninstall`: Removes the FPM pool.

## Properties

| Name                | Type            | Default                              | Description                                                                           |
| ------------------- | --------------- | ------------------------------------ | ------------------------------------------------------------------------------------- |
| `pool_name`         | `String`        | The name of the FPM pool             |                                                                                       |
| `listen`            | `String`        | `/var/run/php<version>-fpm.sock` (RHEL & Amazon) or `/var/run/php/php<version>-fpm.sock` (Debian) | The listen address |
| `user`              | `String`        | The webserver user for your distro.  | The user to run the FPM under                                                         |
| `group`             | `String`        | The webserver group for your distro. | The group to run the FPM under                                                        |
| `process_manager`   | `String`        | `dynamic`                            | Process manager to use - see <https://www.php.net/manual/en/install.fpm.configuration.php> |
| `max_children`      | `Integer`       | `5`                                  | Max children to scale to                                                              |
| `start_servers`     | `Integer`       | `2`                                  | Number of servers to start the pool with                                              |
| `min_spare_servers` | `Integer`       | `1`                                  | Minimum number of servers to have as spares                                           |
| `max_spare_servers` | `Integer`       | `3`                                  | Maximum number of servers to have as spares                                           |
| `chdir`             | `String`        | `/`                                  | The startup working directory of the pool                                             |
| `additional_config` | `Hash`          | `{}`                                 | Additional parameters in JSON                                                         |
| `fpm_ini_control`   | `[true, false]` | `false`                              | Whether to add a new `php.ini` file for FPM

## Examples

Install a FPM pool named 'default'

```ruby
php_fpm_pool 'default' do
  action :install
end
```
