#
# Author::  James Cuzella (<james.cuzella@lyraphase.com>)
# Cookbook Name:: php
# Recipe:: module_curl
#
# Copyright 2009-2011, Opscode, Inc.
# Copyright 2014, James Cuzella
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

case node['platform_family']
when 'debian'
  package 'php5-mcrypt' do
    action :upgrade
  end

  directory node['php']['ext_conf_dir'] do
    owner 'root'
    group 'root'
    mode 0755
    action :create
  end
  
  cookbook_file 'mcrypt.ini' do
    action :create
    path "#{node['php']['ext_conf_dir']}/mcrypt.ini"
    owner 'root'
    group 'root'
    mode 0644
  end

  link '/etc/php5/mods-available/mcrypt.ini' do
    to "#{node['php']['ext_conf_dir']}/mcrypt.ini"
    only_if { ::File.exists? '/etc/php5/mods-available' }
  end

  [ node['php']['conf_dir'],
    '/etc/php5/cgi',
    '/etc/php5/apache2'
  ].each do |conf_dir|
    link "#{conf_dir}/conf.d/20-mcrypt.ini" do
      to "/etc/php5/mods-available/mcrypt.ini"
      only_if { ::File.exists?('/etc/php5/mods-available/mcrypt.ini') && ::File.exists?("#{conf_dir}/conf.d") }
    end
  end
else
  Chef::Log.warn("#{cookbook_name}::#{recipe_name} only supports debian platform family")
end
