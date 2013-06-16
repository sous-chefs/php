#
# Author::  Panagiotis Papadomitsos (<pj@ezgr.net>)
#
# Cookbook Name:: php
# Attribute:: fpm
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

case node['platform_family']
when 'rhel', 'fedora'
  default['php']['fpm_conf_dir']  = '/etc'
  default['php']['fpm_pool_dir']  = '/etc/php-fpm.d'
  default['php']['fpm_log_dir']   = '/var/log/php-fpm'
  default['php']['fpm_pidfile']   = '/var/run/php-fpm/php-fpm.pid'
  default['php']['fpm_logfile']   = '/var/log/php-fpm/fpm-master.log'
  default['php']['fpm_rotfile']   = '/etc/logrotate.d/php-fpm'
when 'debian'
  default['php']['fpm_conf_dir']  = '/etc/php5/fpm'
  default['php']['fpm_pool_dir']  = '/etc/php5/fpm/pool.d'
  default['php']['fpm_log_dir']   = '/var/log/php5-fpm'
  default['php']['fpm_pidfile']   = '/var/run/php5-fpm.pid'
  default['php']['fpm_logfile']   = '/var/log/php5-fpm/fpm-master.log'
  default['php']['fpm_rotfile']   = '/etc/logrotate.d/php5-fpm'
else
  default['php']['fpm_conf_dir']  = '/etc/php5/fpm'
  default['php']['fpm_pool_dir']  = '/etc/php5/fpm/pool.d'
  default['php']['fpm_log_dir']   = '/var/log/php5-fpm'
  default['php']['fpm_pidfile']   = '/var/run/php5-fpm.pid'
  default['php']['fpm_logfile']   = '/var/log/php5-fpm/fpm-master.log'
  default['php']['fpm_rotfile']   = '/etc/logrotate.d/php5-fpm'
end
