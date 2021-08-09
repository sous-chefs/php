#
# Author::  Christo De Lange (<opscode@dldinternet.com>)
# Cookbook:: php
# Recipe:: ini
#
# Copyright:: 2011-2021, Chef Software, Inc.
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

if node['php']['fpm_ini_control']

  service node['php']['fpm_service'] do
    action :enable
  end

  template "#{node['php']['fpm_conf_dir']}/php.ini" do
    source node['php']['ini']['template']
    cookbook node['php']['ini']['cookbook']
    owner 'root'
    group node['root_group']
    mode '0644'
    manage_symlink_source true
    variables(directives: node['php']['directives'])
    notifies :restart, "service[#{node['php']['fpm_service']}]"
    not_if { node['php']['fpm_conf_dir'].nil? }
  end

end

template "#{node['php']['conf_dir']}/php.ini" do
  source node['php']['ini']['template']
  cookbook node['php']['ini']['cookbook']
  owner 'root'
  group node['root_group']
  mode '0644'
  manage_symlink_source true
  variables(directives: node['php']['directives'])
end
