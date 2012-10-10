#
# Author::  Seth Chisamore (<schisamo@opscode.com>)
# Author::  Panagiotis Papadomitsos (<pj@ezgr.net>)
#
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

pkgs = value_for_platform_family(
  [ "rhel", "fedora" ] => %w{ php php-common php-devel php-cli php-pear },
  "debian" => %w{ php5-cgi php5 php5-dev php5-cli php-pear }
)

include_recipe "yumrepo::atomic" if platform?("centos", "redhat")

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

template "#{node['php']['conf_dir']}/php.ini" do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode 00644
end

if platform_family?("debian")
  template "#{node['php']['cgi_conf_dir']}/php.ini" do
    source "php.ini.erb"
    owner "root"
    group "root"
    mode 0644
  end
end

[ node["php"]["session_dir"], node["php"]["upload_dir"] ].each do |dir|
  directory dir do
    owner "root"
    group "root"
    mode 01777
    action :create
    recursive true
  end
end

if node["php"]["tmpfs"]
  total_mem = (node.memory.total.to_i / 1024) + (node.memory.swap.total.to_i / 1024)
  if total_mem < node["php"]["tmpfs_size"].to_i
    Chef::Log.info('You have specified a much bigger tmpfs session store than you can handle. Add more memory or swap or adjust the tmpfs size!')
  else
    [ node["php"]["session_dir"], node["php"]["upload_dir"] ].each do |dir|
      mount dir do
        device "tmpfs"
        fstype "tmpfs"
        options [ "size=#{node['php']['tmpfs_size']}", "mode=1777", "noatime", "noexec", "nosuid", "nodev" ]
        dump 0
        pass 0
        supports [ :remount => true ]
      end
    end
  end
end
