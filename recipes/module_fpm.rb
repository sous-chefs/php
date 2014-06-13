# Cookbook Name:: php
# Recipe:: module_fpm
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
when 'rhel', 'fedora'
  package 'php-fpm' do
    action :install
  end
  service 'php-fpm' do
    action :enable :start
  end
when 'debian'
  package 'php5-fpm' do
    action :install
  end
<<<<<<< HEAD
  service 'php5-fpm' do
    action :enable :start
  end
=======
end

service 'php-fpm' do
  action [ :enable, :start ]
>>>>>>> adc5a84895c00fe3cc6b25ed38e996ac1cc3f9a6
end
