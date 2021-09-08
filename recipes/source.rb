#
# Author::  Seth Chisamore (<schisamo@chef.io>)
# Cookbook:: php
# Recipe:: source
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

if platform?('debian') && node['platform_version'].to_i == 9
  Chef::Log.fatal 'Debian 9 is not supported when building from source'
end

version = node['php']['version']
configure_options = node['php']['configure_options'].join(' ')
ext_dir_prefix = node['php']['ext_dir'] ? "EXTENSION_DIR=#{node['php']['ext_dir']}" : ''

php_exists = if node['php']['src_recompile']
               false
             else
               "$(which #{node['php']['bin']}) --version | grep #{version}"
             end

build_essential

include_recipe 'yum-epel' if platform_family?('rhel', 'amazon')

package node['php']['src_deps']

log "php_exists == #{php_exists}"

remote_file "#{Chef::Config[:file_cache_path]}/php-#{version}.tar.gz" do
  source "#{node['php']['url']}/php-#{version}.tar.gz"
  checksum node['php']['checksum']
  action :create_if_missing
  not_if php_exists
  notifies :run, 'execute[un-pack php]', :immediately
end

execute 'un-pack php' do
  cwd Chef::Config[:file_cache_path]
  command "tar -zxf php-#{version}.tar.gz"
  creates "#{Chef::Config[:file_cache_path]}/php-#{version}"
  action :nothing
end

if node['php']['ext_dir']
  directory node['php']['ext_dir'] do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
  end
end

# PHP is unable to find the GMP library on Ubuntu 16.04
# This symlink brings the file inside of the included libraries
link '/usr/include/gmp.h' do
  to '/usr/include/x86_64-linux-gnu/gmp.h'
  only_if { platform?('ubuntu') && node['platform_version'].to_f == 16.04 }
end

execute 'clean build' do
  cwd "#{Chef::Config[:file_cache_path]}/php-#{version}"
  command 'make clean'
  only_if { node['php']['src_recompile'] }
end

execute 'configure php' do
  cwd "#{Chef::Config[:file_cache_path]}/php-#{version}"
  command "#{ext_dir_prefix} ./configure #{configure_options}"
  not_if php_exists
end

execute 'build and install php' do
  cwd "#{Chef::Config[:file_cache_path]}/php-#{version}"
  command "make -j #{node['cpu']['total']} && make install"
  not_if php_exists
end

directory node['php']['conf_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
end

directory node['php']['ext_conf_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
end

include_recipe 'php::ini'
