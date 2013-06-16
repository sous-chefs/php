#
# Author::  Panagiotis Papadomitsos (<pj@ezgr.net>)
#
# Cookbook Name:: php
# Recipe:: module_common
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

pkg = value_for_platform_family(
    [ 'rhel', 'fedora' ] => %w{ php-common php-cli php-mbstring php-gd php-intl php-pspell php-mcrypt php-soap php-sqlite php-xml php-xmlrpc }, 
    'debian' => %w{ php5-curl php5-json php5-cli php5-gd php5-intl php5-pspell php5-mcrypt php5-mhash php5-sqlite php5-xsl php5-xmlrpc }
)

pkg.each do |ppkg| 
	package ppkg do
	  action :install
	end
end
