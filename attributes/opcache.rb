#
# Author:: Panagiotis Papadomitsos (pj@ezgr.net)
#
# Cookbook Name:: php
# Attribute:: opcache
#
# Copyright:: 2012, Panagiotis Papadomitsos
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

default['php']['opcache']['version'] = '7.0.2'

default['php']['opcache']['options'] = {
  'enable_cli'              => 0,
  'memory_consumption'      => 256,
  'interned_strings_buffer' => 16,
  'max_accelerated_files'   => 8192,
  'max_wasted_percentage'   => 10,
  'use_cwd'                 => 1,
  'validate_timestamps'     => 1,
  'revalidate_freq'         => 60,
  'revalidate_path'         => 1,
  'save_comments'           => 1,
  'load_comments'           => 1,
  'fast_shutdown'           => 1,
  'enable_file_override'    => 0,
  'optimization_level'      => '0xffffffff',
  'inherited_hack'          => 1,
  'blacklist_filename'      => '',
  'max_file_size'           => 0,
  'consistency_checks'      => 0,
  'force_restart_timeout'   => 180,
  'error_log'               => '',
  'log_verbosity_level'     => 2,
  'preferred_memory_model'  => '',
  'protect_memory'          => 0
}
