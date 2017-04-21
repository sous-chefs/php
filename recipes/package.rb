#
# Author::  Seth Chisamore (<schisamo@chef.io>)
# Author::  Lucas Hansen (<lucash@chef.io>)
# Cookbook:: php
# Recipe:: package
#
# Copyright:: 2013-2017, Chef Software, Inc.
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

node['php']['packages'].each do |pkg|
  package pkg do
    action :install
    options node['php']['package_options']
  end
end unless %w(rhel debian amazon suse).include?(node['platform_family'])

package node['php']['packages'] do
  action :install
  options node['php']['package_options']
  only_if { %w(rhel debian amazon suse).include?(node['platform_family']) }
end

include_recipe 'php::ini'
