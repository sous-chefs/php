#
# Author:: Panagiotis Papadomitsos (pj@ezgr.net)
#
# Cookbook Name:: php
# Recipe:: module_opcache
#
# Copyright:: 2013, Panagiotis Papadomitsos
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

tmp = Chef::Config['file_cache_path'] || '/tmp'
ver = node['php']['opcache']['version']
lib = value_for_platform_family(
  [ 'rhel', 'fedora' ] => '/var/lib/php',
  'debian' => '/var/lib/php5'
)

if node['recipes'].include?('php::fpm')
  svc = value_for_platform_family(
      [ 'rhel', 'fedora' ] => 'php-fpm',
      'debian' => 'php5-fpm'
  )
end

if platform_family?('rhel')
  %w{ httpd-devel pcre pcre-devel }.each { |pkg| package pkg }
end

if ((Chef::Config[:solo] && !File.exists?("#{lib}/.zend-opcache-#{ver}-installed")) ||
    (!node['php']['opcache'].attribute?('version_installed')) ||
    (node['php']['opcache'].attribute?('version_installed') && node['php']['opcache']['version_installed'] != ver))

  git "#{tmp}/php-opcache-#{ver}" do
    repository 'git://github.com/zendtech/ZendOptimizerPlus.git'
    reference "v#{ver}"
    action :checkout
  end

  execute 'php-opcache-phpize' do
    command 'phpize'
    cwd "#{tmp}/php-opcache-#{ver}"
    creates "#{tmp}/php-opcache-#{ver}/configure"
    action :run
  end

  execute 'php-opcache-configure' do
    command './configure --enable-opcache'
    cwd "#{tmp}/php-opcache-#{ver}"
    creates "#{tmp}/php-opcache-#{ver}/config.h"
    action :run
  end

  execute 'php-opcache-build' do
    command "make -j#{node['cpu']['total']}"
    cwd "#{tmp}/php-opcache-#{ver}"
    creates "#{tmp}/php-opcache-#{ver}/modules/opcache.so"
    action :run
    notifies :run, 'execute[php-opcache-install]', :immediately
  end

  execute 'php-opcache-install' do
    command 'make install'
    cwd "#{tmp}/php-opcache-#{ver}"
    action :nothing
  end

  if Chef::Config[:solo]
    file "#{lib}/.zend-opcache-#{ver}-installed" do
      owner 'root'
      group 'root'
      action :create_if_missing
    end
  else
    node.set['php']['opcache']['version_installed'] = ver
  end

end

# We install the PHP packages at compile time in order to have the php-config executable available for query
ext_dir = `php-config --extension-dir`.chomp
ext_dir.empty? && raise('Could not execute php-config to locate the PHP extension dir. Please install the PHP development libraries')
Chef::Log.info("Discovered PHP extension dir to be #{ext_dir}")

template "#{node['php']['ext_conf_dir']}/00-opcache.ini" do
  source 'opcache.ini.erb'
  owner 'root'
  group 'root'
  mode 00644
  variables({
    :ext_dir => ext_dir
  })
  if node['recipes'].include?('php::fpm')
    notifies :restart, svc
  end
end
