#
# Author::  Matheus Ashton (<matheusashton@gmail.com>)
# Cookbook Name:: php
# Recipe:: module_memcache
#
# Copyright 2009-2011, Opscode, Inc.
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
when "debian", "ubuntu"
  package "php5-intl" do
    action :install
  end
else
  php_pear "intl" do
    action :install
  end
end
