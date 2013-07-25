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

bin_dir = "#{node['php']['composer']['dir']}/bin"
directory bin_dir do
  action :create
  recursive true
end

execute "install_composer" do
  action :run
  cwd bin_dir
  command %{#{node['php']['bin']} -r "eval('?>'.file_get_contents('https://getcomposer.org/installer'));"}
end

composer_dir = node["php"]["composer"]["dir"].gsub("/", "\\")
ENV["COMPOSER_HOME"] = composer_dir
env "COMPOSER_HOME" do
  value composer_dir
end

if platform? "windows"

  execute "create_composer_executable" do
    action :run
    cwd bin_dir
    command %{echo @php "%~dp0composer.phar" %*>composer.bat}
  end

  ENV["PATH"] += ";#{composer_dir}\\bin"
  windows_path "#{composer_dir}\\bin"
  
end

comp = "bin\\#{node['php']['composer']['bin']}"
execute "configure_composer" do
  action :run
  cwd node['php']['composer']['dir']
  command [
           "#{comp} init --stability dev --no-interaction",
           "#{comp} config bin-dir bin",
           "#{comp} config vendor-dir vendor"
          ].join(" && ")
end

