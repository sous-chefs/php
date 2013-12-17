#
# Author::  Lucas Hansen (<lucash@opscode.com>)
# Author::  Julian C. Dunn (<jdunn@getchef.com>)
# Cookbook Name:: php
# Recipe:: composer
#
# Copyright 2013, Chef Software, Inc.
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

if platform?('windows')

  windows_package "Composer - Php Dependency Manager" do
    source node['php']['composer']['package']
    options %W[
          /VERYSILENT
    ].join(' ')
  end

  install_dir = "#{node['php']['composer']['dir']).gsub('/', '\\')}\\bin"

  ENV['PATH'] += ";#{install_dir}"
  windows_path install_dir

else

  remote_file "#{node['php']['conf_dir']}/composer.phar" do
    source node['php']['composer']['package']
  end

end