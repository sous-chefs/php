#
# Author::  Panagiotis Papadomitsos (<pj@ezgr.net>)
#
# Cookbook Name:: php
# Resource:: fpm
#
# Copyright 2009-2012, Panagiotis Papadomitsos
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

default_action :add

actions :add, :remove

attribute :name,                :regex => /^[a-zA-Z0-9\._\-]{0,32}$/, :required => true, :name_attribute => true
attribute :user,                :kind_of => String, :required => true
attribute :group,               :kind_of => String, :required => true
attribute :socket,              :kind_of => [ FalseClass, TrueClass ], :default => false
attribute :socket_path,         :kind_of => String, :default => '/tmp/php-fpm.sock'
attribute :socket_user,         :regex => /^[a-zA-Z0-9\._\-]{0,32}$/, :default => 'root'
attribute :socket_group,        :regex => /^[a-zA-Z0-9\._\-]{0,32}$/, :default => 'root'
attribute :socket_perms,        :regex => /^[0-1]?[0-7][0-7][0-7]$/,  :default => '0666'
attribute :ip_address,          :regex => /^([0-2]?[0-9]?[0-9]\.){3}[0-2]?[0-9]?[0-9]$/, :default => '127.0.0.1'
attribute :port,                :kind_of => Integer,  :default => 9000
attribute :ip_whitelist,        :kind_of => Array,    :default => [ '127.0.0.1' ]
attribute :max_children,        :kind_of => Integer,  :default => 64
attribute :start_servers,       :kind_of => Integer,  :default => 4
attribute :min_spare_servers,   :kind_of => Integer,  :default => 4
attribute :max_spare_servers,   :kind_of => Integer,  :default => 32
attribute :max_requests,        :kind_of => Integer,  :default => 10000
attribute :backlog,             :kind_of => Integer,  :default => 1024
attribute :status_url,          :regex => /^(\/[a-z0-9\-]*|)$/,   :default => '/fpm-status'
attribute :ping_url,            :regex => /^(\/[a-z0-9\-]*|)$/,   :default => '/fpm-ping'
attribute :ping_response,       :kind_of => String,   :default => 'pong'
attribute :log_filename,        :kind_of => String,   :default => ''
attribute :log_format,          :kind_of => String,   :default => '%R - %u %t " %m %r " %s'
attribute :slow_filename,       :kind_of => String,   :default => ''
attribute :slow_timeout,        :kind_of => Integer,  :default => 0
attribute :valid_extensions,    :kind_of => Array,    :default => [ '.php', '.php3', '.php4', '.php5', '.phtml' ]
attribute :terminate_timeout,   :kind_of => Integer,  :default => 0
attribute :initial_directory,   :kind_of => String,   :default => '/'
attribute :flag_overrides,      :kind_of => Hash,     :default => {}
attribute :value_overrides,     :kind_of => Hash,     :default => {}
attribute :env_overrides,       :kind_of => Hash,     :default => {}
