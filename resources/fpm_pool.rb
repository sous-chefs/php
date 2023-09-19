#
# Author:: Chris Marchesi <cmarchesi@paybyphone.com>
# Cookbook:: php
# Resource:: fpm_pool
#
# Copyright:: 2015-2021, Chef Software, Inc <legal@chef.io>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# Author:: Chris Marchesi <cmarchesi@paybyphone.com>
# Cookbook:: php
# Resource:: fpm_pool
#
# Copyright:: 2015-2021, Chef Software, Inc <legal@chef.io>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

unified_mode true
include Php::Cookbook::Helpers

property :additional_config, Hash, default: {}
property :chdir, String, default: '/'
property :default_conf, String, default: lazy { php_fpm_default_conf }
property :fpm_package, String, default: lazy { php_fpm_package }
property :group, String, default: lazy { php_fpm_group(install_type) }
property :install_type, String, equal_to: %w(package source), default: 'package'
property :listen, String, default: lazy { php_fpm_socket }
property :listen_group, String, default: lazy { php_fpm_listen_group(install_type) }
property :listen_user, String, default: lazy { php_fpm_listen_user(install_type) }
property :max_children, Integer, default: 5
property :max_spare_servers, Integer, default: 3
property :min_spare_servers, Integer, default: 1
property :pool_cookbook, String, default: lazy { php_fpm_pool_cookbook }
property :pool_dir, String, default: lazy { php_fpm_pool_dir }
property :pool_name, String, name_property: true
property :pool_template, String, default: lazy { php_fpm_pool_template }
property :process_manager, String, default: 'dynamic'
property :service, String, default: lazy { php_fpm_service }
property :start_servers, Integer, default: 2
property :user, String, default: lazy { php_fpm_user(install_type) }

property :fpm_ini_control, [true, false], default: false
property :fpm_conf_dir, String, default: lazy { php_fpm_conf_dir }
property :ini_template, String, default: lazy { php_ini_template }
property :ini_cookbook, String, default: lazy { php_ini_cookbook }
property :directives, Hash, default: {}
property :ext_dir, String, default: lazy { php_ext_dir }

action :install do
  # Ensure the FPM package is installed, and the service is registered
  install_fpm_package
  register_fpm_service

  if new_resource.fpm_ini_control
    php_ini 'fpm_ini' do
      conf_dir new_resource.fpm_conf_dir
      ini_template new_resource.ini_template
      ini_cookbook new_resource.ini_cookbook
      directives new_resource.directives
      ext_dir new_resource.ext_dir
      notifies :restart, "service[#{new_resource.service}]"
      not_if { new_resource.fpm_conf_dir.nil? }
    end
  end

  # I wanted to have this as a function in itself, but doing this seems to
  # break testing suites?
  template "#{new_resource.pool_dir}/#{new_resource.pool_name}.conf" do
    source new_resource.pool_template
    action :create
    cookbook new_resource.pool_cookbook
    variables(
      fpm_pool_name: new_resource.pool_name,
      fpm_pool_user: new_resource.user,
      fpm_pool_group: new_resource.group,
      fpm_pool_listen: new_resource.listen,
      fpm_pool_listen_user: new_resource.listen_user,
      fpm_pool_listen_group: new_resource.listen_group,
      fpm_pool_manager: new_resource.process_manager,
      fpm_pool_max_children: new_resource.max_children,
      fpm_pool_start_servers: new_resource.start_servers,
      fpm_pool_min_spare_servers: new_resource.min_spare_servers,
      fpm_pool_max_spare_servers: new_resource.max_spare_servers,
      fpm_pool_chdir: new_resource.chdir,
      fpm_pool_additional_config: new_resource.additional_config
    )
    notifies :restart, "service[#{new_resource.service}]"
  end
end

action :uninstall do
  # Ensure the FPM package is installed, and the service is registered
  register_fpm_service
  # Delete the FPM pool.
  file "#{new_resource.pool_dir}/#{new_resource.pool_name}.conf" do
    action :delete
  end
end

action_class do
  def install_fpm_package
    # Install the FPM package for this platform, if it's available
    # Fail the run if it's an unsupported OS (FPM package name not populated)
    # also, this is skipped for source
    return if new_resource.install_type == 'source'

    raise 'PHP-FPM package not found (you probably have an unsupported distro)' if new_resource.fpm_package.nil?

    file new_resource.default_conf do
      action :nothing
    end

    package new_resource.fpm_package do
      action :install
      notifies :delete, "file[#{new_resource.default_conf}]", :immediately
    end
  end

  def register_fpm_service
    service new_resource.service do
      action :enable
    end
  end
end
