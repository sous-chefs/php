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
| `fpm_ini_control`   | `[true, false]` | `false`                              | Whether to add a new `php.ini` file for FPM                                           |


## Examples

1. Install a FPM pool named 'default'

   ```ruby
   php_fpm_pool 'default' do
     action :install
   end
   ```

2. Multiple FPM Pools
   Changes in configuration during provisioning of an FPM pool will lead to a restart of the `phpX.Y-fpm` service.
   If more than `5` FPM pools are affected by a configuration change, this will lead to subsequent `5+` service restarts.
   However, `systemd` will deny this number of subsequent service restarts with the following error:

   ```
   php8.1-fpm.service: Start request repeated too quickly.
   php8.1-fpm.service: Failed with result 'start-limit-hit'.
   Failed to start The PHP 8.1 FastCGI Process Manager.
   ```

   This behavior is due to the `unified_mode true` setting of an `fpm_pool` custom resource, which is a [default setting](https://docs.chef.io/deprecations_unified_mode/) for `chef-clients v18+`. In this mode, notifications set as `:delayed` within a custom resource action (like `action :install`) are queued to be processed once the action completes (i.e., at the end of the resource `action :install` block), rather than waiting until the end of the Chef client run.

   ### Possible Workaround

   In a wrapper cookbook, define a `ruby_block` with a call to the `sleep(X)` function, which will be called upon an `fpm_pool` resource update:

   ```ruby
   # frozen_string_literal: true
   #
   # Cookbook:: my_php
   # Recipe:: fpm

   ruby_block "wait after_service restart" do
     block do
       Chef::Log.info("Waiting 5 seconds after php-fpm service restart...")
       sleep(5)
     end
     action :nothing
   end

   # Fancy loop on all defined pools for this node
   node['php']['fpm_pool'].each do |pool_name, parameters|
     php_fpm_pool pool_name do
       parameters.each do |param, value|
         send(param, value)
       end unless parameters.nil?
       notifies :run, "ruby_block[wait after_service restart]", :immediately
     end
   end
   ```
