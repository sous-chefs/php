#
# Author::  Lucas Hansen (<lucash@opscode.com>)
# Cookbook Name:: php
# Recipe:: composer
#
# Copyright 2013, Opscode, Inc.
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

include_recipe "php"
include_recipe "git"

execute "install_composer" do
  action :run
  cwd Chef::Config[:file_cache_path]
  command %{#{node['php']['bin']} -r "eval('?>'.file_get_contents('https://getcomposer.org/installer'));"}
end

# Ensure that composer is on the PATH
if platform? 'windows'
  php_dir = node['php']['conf_dir']
  execute "move composer.phar #{php_dir.gsub('/', '\\')}\\composer.phar" do
    cwd Chef::Config[:file_cache_path]
  end
  
  template "#{php_dir}/#{node['php']['composer']['bin']}" do
    source "composer.bat.erb"
  end
else
  execute "mv composer.phar /usr/local/bin/#{node['php']['composer']['bin']}" do
    cwd Chef::Config[:file_cache_path]
  end
end

# Ensure that packages installed by composer on the PATH, but ONLY DURING THE CHEF RUN!
if platform? 'windows'
  ENV['PATH'] += ";#{node['php']['composer']['dir'].gsub('/', '\\')}\\bin"
else
  ENV['PATH'] += ":#{node['php']['composer']['dir']}/bin"
end

directory node['php']['composer']['dir'] do
  action :create
  recursive true
end

bin = node['php']['composer']['bin']
execute "configure_composer" do
  action :run
  cwd node['php']['composer']['dir']
  command [
           "#{bin} init --stability dev --no-interaction",
           "#{bin} config bin-dir bin",
           "#{bin} config vendor-dir vendor"
          ].join(" && ")
end

