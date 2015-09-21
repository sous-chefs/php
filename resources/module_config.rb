#
# Author:: Jonathan Serafini <jonathan@serafini.ca>
# Cookbook Name:: php
# Resource:: php_module_config
#
# Copyright:: 2011-2015, Chef Software, Inc <legal@chef.io>
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

default_action [:create, :enable]
actions :create, :delete, :enable, :disable

state_attrs :priority,
            :directives,
            :extensions

attribute :conf_name,
  :kind_of => String,
  :name_attribute => true

attribute :path,
  :kind_of => String,
  :default => lazy { |r| "#{node['php']['ext_conf_dir']}/#{r.conf_name}.ini" }

attribute :priority,
  :kind_of => String

attribute :cookbook,
  :kind_of => String,
  :default => "php"

attribute :source,
  :kind_of => String,
  :default => "extension.ini.erb"

attribute :directives,
  :kind_of => Hash,
  :default => {}

attribute :extensions,
  :kind_of => Hash,
  :default => {}

attribute :php_sapi,
  :kind_of => [String, Array],
  :default => "ALL"

