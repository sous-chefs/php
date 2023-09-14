#
# Author::  Joshua Timberman (<joshua@chef.io>)
# Author::  Seth Chisamore (<schisamo@chef.io>)
# Cookbook:: php
# Recipe:: default
#
# Copyright:: 2009-2023, Chef Software, Inc.
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

::Chef::DSL::Recipe.include Php::Cookbook::Helpers

php_install 'php'

# TODO: make php_pear_channels configurable
php_pear_channels.each do |channel|
  php_pear_channel channel do
    binary php_pear_path
    action :update
    only_if { php_pear_setup }
  end
end

php_ini 'ini'
