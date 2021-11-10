#
# Author::  Jeff Byrnes (<thejeffbyrnes@gmail.com>)
# Cookbook:: php
# Recipe:: package
#
# Copyright:: 2021, Jeff Byrnes
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

if platform_family?('rhel', 'amazon')
  include_recipe 'yum-remi-chef::remi'
elsif platform?('ubuntu')
  include_recipe 'ondrej_ppa_ubuntu'
elsif platform?('debian')
  # use sury repo for debian (https://deb.sury.org/)
  apt_repository 'sury-php' do
    uri 'https://packages.sury.org/php/'
    key 'https://packages.sury.org/php/apt.gpg'
    components %w(main)
  end
end

include_recipe 'php::package'
