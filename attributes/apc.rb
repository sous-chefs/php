#
# Author:: Panagiotis Papadomitsos (pj@ezgr.net)
#
# Cookbook Name:: php
# Attribute:: apc
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

default['php']['apc']['shm_size'] = '128M'
default['php']['apc']['local_size'] = '128M'
default['php']['apc']['ttl'] = '7200'
default['php']['apc']['user_ttl'] = '7200'
