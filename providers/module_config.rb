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

action :create do
  run_action_and_track(:create) { template_resource }
end

action :delete do
  run_action_and_track(:delete) { template_resource }
end

action :enable do
  resource_sapi_list.each do |sapi_name|
    run_action_and_track(:run) do
      activation_resource("php5enmod", sapi_name)
    end
  end
end

action :disable do
  resource_sapi_list.each do |sapi_name|
    run_action_and_track(:run, sapi_name) do
      activation_resource("php5dismod", sapi_name)
    end
  end
end


def run_action_and_track(action, &block)
  res = block.call
  res.action(action)
  new_resource.updated_by_last_action(res.updated_by_last_action?)
  res
end

def activation_resource(command, sapi_name)
  new_resource = @new_resource
  provider_scope = self
  cmd = "/usr/sbin/#{command}"

  execute "#{cmd} -s #{sapi_name} #{new_resource.conf_name}" do
    case command
    when "php5enmod"
      not_if do
        provider_scope.php_conf_enabled?(new_resource.conf_name, sapi_name)
      end
    when "php5dismod"
      only_if do
        provider_scope.php_conf_enabled?(new_resource.conf_name, sapi_name)
      end
    end
    action :nothing
  end
end

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

#  list of desired php sapi ( debian-like only )
#
def resource_sapi_list
  if new_resource.php_sapi.include?("ALL") then php_sapi_list
  elsif with_php_query? then Array(new_resource.php_sapi)
  else php_sapi_list
  end
end

# list of installed php sapi ( debian-like only )
#
def php_sapi_list
  @php_sapi_list ||= 
    if with_php_query?
      `/usr/sbin/php5query -q -S`.split("\n")
    else Array.new
    end
end

# verify whether config is enabled for php sapi ( debian-like only )
#
def php_conf_enabled?(conf_name, sapi_name)
  if with_php_query?
    `/usr/sbin/php5query -q -s #{sapi_name} -m #{conf_name}`
    $?.exitstatus == 0
  else true
  end
end

# verify whether /usr/sbin/php5query exists ( debian-like boxes )
#
def with_php_query?
  @with_php_query = ::File.exists?("/usr/sbin/php5query") if @with_php_query.nil?
  @with_php_query
end

