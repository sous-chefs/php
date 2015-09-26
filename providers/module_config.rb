#
# Author:: Jonathan Serafini <jonathan@serafini.ca>
# Cookbook Name:: php
# Provider:: php_module_config
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

def whyrun_supported? 
  true
end

# disable use_inline_resources so as to expose resources in the same manner
# that php_pear would have.
#
# due to this, we wrap all resources in the run_action_and_track method so as 
# to bubble up updated_by_last_action.
#
#use_inline_resources

# create the configuration file
#
action :create do
  run_action_and_track(:create) { template_resource }
end

# delete the configuration file
#
action :delete do
  run_action_and_track(:delete) { template_resource }
end

# optionally enable the configuration file for a given php sapi (cgi,cli,fpm)
# while also ensuring that this is done for the correct priorirty
#
action :enable do
  if supports_php5query?
    resource_sapi_list.each do |sapi_name|
      sapi_files_found(sapi_name).each do |sapi_file|
        unless sapi_file == sapi_file_path(sapi_name, @new_resource.priority)
          run_action_and_track(:delete) do
            activation_resource(sapi_name, sapi_file)
          end
        end
      end

      run_action_and_track(:create) do
        res = activation_resource(sapi_name)
        res.not_if { sapi_files_found(sapi_name, @new_resource.priority).any? }
        res
      end
    end
  else Chef::Log.info("#{new_resource} system does not support enabling")
  end
end

# optionally disable the configuration file for a given php sapi (cgi,cli,fpm)
# while also ensuring that this is done for the correct priorirty
#
action :disable do
  if supports_php5query?
    resource_sapi_list.each do |sapi_name|
      run_action_and_track(:delete) do
        res = activation_resource(sapi_name)
        res.only_if { sapi_files_found(sapi_name, @new_resource.priority).any? }
        res
      end
    end
  else Chef::Log.info("#{new_resource} system does not support disabling")
  end
end

# helper method to execute an action on a resource and collect whether
# it was updated or not .. hit is a poor man's use_inline_resources
#
def run_action_and_track(action, &block)
  res = block.call
  res.run_action(action) 
  @new_resource.updated_by_last_action(true) if res.updated_by_last_action?
  res
end

# the resource containing the configuration data
#
def template_resource
  new_resource = @new_resource

  @template_resource ||=
    template new_resource.path do
      source new_resource.source
      cookbook new_resource.cookbook
      owner 'root'
      group 'root'
      mode  '0644'
      variables :name => new_resource.conf_name,
                :priority => new_resource.priority,
                :extensions => new_resource.extensions,
                :directives => new_resource.directives
      action :nothing
    end
end

# the resource supporting enabling / disabling of modules
#
def activation_resource(sapi_name, sapi_file = nil)
  new_resource = @new_resource
  sapi_file ||= sapi_file_path(sapi_name, new_resource.priority)
  link sapi_file do
    to new_resource.path
    action :nothing
  end
end

# determine whether php5query exists ( debian like systems )
# this is required so that, on debian systems, we symlink the configuration
# file into the respective SAPI configuration directories.
#
def supports_php5query?
  if @supports_php5query.nil?
  then @supports_php5query = ::File.exists?("/usr/sbin/php5query")
  else @supports_php5query
  end
end

# list of the desired PHP SAPI to enable/disable for
#
def sapi_list
  if @sapi_list.nil?
    @sapi_list = if supports_php5query?
                       `/usr/sbin/php5query -q -S`.split("\n")
                     else Array.new
                     end
  else @sapi_list
  end
end

# list of the selected (new_resource.php_sapi) sapi
#
def resource_sapi_list
  if new_resource.php_sapi.include?("ALL")
    sapi_list
  elsif supports_php5query?
    Array(new_resource.php_sapi)
  else
    sapi_list
  end
end

# configuration directory for a given sapi
#
def sapi_directory(sapi)
  "/etc/php5/#{sapi}/conf.d"
end

# file path for a given sapi and priority
#
def sapi_file_path(sapi, priority)
  ::File.join(sapi_directory(sapi), "#{priority}-#{@new_resource.conf_name}.ini")
end

# list of files matching sapi, new_resource.conf_name and a given priority
#
def sapi_files_found(sapi, priority = "*")
  ::Dir.glob(sapi_file_path(sapi, priority))
end

