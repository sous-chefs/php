#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Author:: Panagiotis Papadomitsos (pj@ezgr.net)
#
# Cookbook Name:: php
# Attribute:: default
#
# Copyright 2011, Opscode, Inc.
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

lib_dir = kernel['machine'] =~ /x86_64/ ? 'lib64' : 'lib'

default['php']['directives'] = {}

case node['platform_family']
when 'rhel', 'fedora'
  default['php']['conf_dir']      = '/etc'
  default['php']['ext_conf_dir']  = '/etc/php.d'
  default['php']['ext_dir']       = "/usr/#{lib_dir}/php/modules"
  default['php']['pear_dir']      = '/usr/share/pear'
  default['php']['session_dir']   = '/var/lib/php/session5'
  default['php']['upload_dir']    = '/var/lib/php/uploads'
when 'debian'
  default['php']['conf_dir']      = '/etc/php5/cli'
  default['php']['apache_conf_dir'] = '/etc/php5/apache2'
  default['php']['cgi_conf_dir']  = '/etc/php5/cgi'
  default['php']['ext_conf_dir']  = '/etc/php5/conf.d'
  default['php']['pear_dir']      = '/usr/share/php'
  default['php']['session_dir']   = '/var/lib/php5/session5'
  default['php']['upload_dir']    = '/var/lib/php5/uploads'
else
  default['php']['conf_dir']      = '/etc/php5/cli'
  default['php']['apache_conf_dir'] = '/etc/php5/apache2'
  default['php']['cgi_conf_dir']  = '/etc/php5/cgi'
  default['php']['ext_conf_dir']  = '/etc/php5/conf.d'
  default['php']['pear_dir']      = '/usr/share/php'
  default['php']['session_dir']   = '/var/lib/php5/session5'
  default['php']['upload_dir']    = '/var/lib/php5/uploads'
end

default['php']['secure_functions']['disable_functions'] = 'dl,posix_kill,posix_mkfifo,posix_setuid,proc_close,proc_open,proc_terminate,shell_exec,system,leak,posix_setpgid,posix_setsid,proc_get_status,proc_nice,show_source,virtual,proc_terminate,inject_code,define_syslog_variables,syslog,posix_uname'

# PHP.ini Settings
default['php']['ini_settings'] = {
  'short_open_tag' => 'On',
  'open_basedir' => '',
  'max_execution_time' => '300',
  'max_input_time' => '300',
  'memory_limit' => '128M',
  'error_reporting' => 'E_ALL & ~E_DEPRECATED & ~E_NOTICE',
  'display_errors' => 'Off',
  'error_log' => '',
  'register_globals' => 'Off',
  'register_long_arrays' => 'Off',
  'post_max_size' => '32M',
  'magic_quotes_gpc' => 'Off',
  'allow_url_fopen' => 'On',
  'allow_url_include' => 'Off',
  'always_populate_raw_post_data' => 'Off',
  'cgi.fix_pathinfo' => '1',
  'upload_max_filesize' => '32M',
  'date.timezone' => 'Europe/Athens',
  'session.cookie_httponly' => '0'
}

default['php']['tmpfs'] = true
default['php']['tmpfs_size'] = '128M'
