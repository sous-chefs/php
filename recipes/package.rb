#
# Author::  Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: php
# Recipe:: package
#
# Copyright 2011, Opscode, Inc.
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

execute "ppa" do
  command "sudo apt-get install python-software-properties"
  action :run
end

execute "add-apt" do
  command "add-apt-repository ppa:ondrej/php5-experimental"
  action :run
end

execute "Update repositotory" do
  command "sudo apt-get update"
  action :run
end

execute "install php5.5" do
  command "sudo apt-get install php5"
  action :run
end


#node['php']['packages'].each do |pkg|
#  package pkg do
 #   action :install
 # end
#end

template "#{node['php']['conf_dir']}/php.ini" do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(:directives => node['php']['directives'])
end

template "/etc/php5/apache2/php.ini" do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  only_if { File.directory?("/etc/php5/apache2") }
end
