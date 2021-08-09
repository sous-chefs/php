#
# Cookbook:: php
# Attributes:: default
#
# Copyright:: 2011-2021, Chef Software, Inc.
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

lib_dir = 'lib'

default['php']['install_method'] = 'package'
default['php']['directives'] = {}
default['php']['bin'] = 'php'

default['php']['pecl'] = 'pecl'

default['php']['version'] = '7.2.31'

default['php']['pear'] = '/usr/bin/pear'
default['php']['pear_setup'] = true
default['php']['pear_channels'] = [
  'pear.php.net',
  'pecl.php.net',
]

default['php']['url'] = 'https://www.php.net/distributions'
default['php']['checksum'] = '796837831ccebf00dc15921ed327cfbac59177da41b33044d9a6c7134cdd250c' # checksum of the .tar.gz files
default['php']['prefix_dir'] = '/usr/local'
default['php']['enable_mod'] = '/usr/sbin/phpenmod'
default['php']['disable_mod'] = '/usr/sbin/phpdismod'

default['php']['ini']['template'] = 'php.ini.erb'
default['php']['ini']['cookbook'] = 'php'

default['php']['fpm_socket'] = '/var/run/php7.2-fpm.sock'
default['php']['fpm_conf_dir'] = nil
default['php']['fpm_ini_control'] = false

case node['platform_family']
when 'rhel', 'amazon'
  lib_dir = node['kernel']['machine'] =~ /x86_64/ ? 'lib64' : 'lib'

  default['php']['conf_dir']      = '/etc'
  default['php']['ext_conf_dir']  = '/etc/php.d'
  default['php']['fpm_user']      = 'nobody'
  default['php']['fpm_group']     = 'nobody'
  default['php']['fpm_listen_user']   = 'nobody'
  default['php']['fpm_listen_group']  = 'nobody'
  default['php']['ext_dir']           = "/usr/#{lib_dir}/php/modules"
  default['php']['fpm_package']       = 'php-fpm'

  default['php']['src_deps'] = if platform?('amazon') || node['platform_version'].to_i < 8
                                 %w(bzip2-devel libc-client-devel curl-devel freetype-devel gmp-devel libjpeg-devel krb5-devel libmcrypt-devel libpng-devel openssl-devel t1lib-devel libxml2-devel libxslt-devel zlib-devel mhash-devel)
                               else # redhat does not name their packages with version on RHEL 6+
                                 %w(bzip2-devel libc-client-devel curl-devel freetype-devel gmp-devel libjpeg-devel krb5-devel libmcrypt-devel libpng-devel openssl-devel libxml2-devel libxslt-devel zlib-devel mhash-devel)
                               end
  default['php']['packages'] = %w(php php-devel php-cli php-pear)
  default['php']['fpm_pooldir'] = '/etc/php-fpm.d'
  default['php']['fpm_default_conf'] = '/etc/php-fpm.d/www.conf'
  default['php']['fpm_service'] = 'php-fpm'
  if node['php']['install_method'] == 'package'
    default['php']['fpm_user']      = 'apache'
    default['php']['fpm_group']     = 'apache'
    default['php']['fpm_listen_user'] = 'apache'
    default['php']['fpm_listen_group'] = 'apache'
  end
when 'debian'
  default['php']['version']          = '7.0.4'
  default['php']['checksum']         = 'f6cdac2fd37da0ac0bbcee0187d74b3719c2f83973dfe883d5cde81c356fe0a8'
  default['php']['conf_dir']         = '/etc/php/7.0/cli'
  default['php']['src_deps']         = %w(libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg-dev libkrb5-dev libmcrypt-dev libpng-dev libssl-dev pkg-config libxml2-dev)
  default['php']['packages']         = %w(php7.0-cgi php7.0 php7.0-dev php7.0-cli php-pear)
  default['php']['disable_mod']      = '/usr/sbin/phpdismod'
  default['php']['enable_mod']       = '/usr/sbin/phpenmod'
  default['php']['fpm_default_conf'] = '/etc/php/7.0/fpm/pool.d/www.conf'
  default['php']['fpm_conf_dir']     = '/etc/php/7.0/fpm'
  default['php']['ext_conf_dir']     = '/etc/php/7.0/mods-available'
  default['php']['fpm_package']      = 'php7.0-fpm'
  default['php']['fpm_pooldir']      = '/etc/php/7.0/fpm/pool.d'
  default['php']['fpm_service']      = 'php7.0-fpm'
  default['php']['fpm_socket']       = '/var/run/php/php7.0-fpm.sock'
  default['php']['fpm_user']         = 'www-data'
  default['php']['fpm_group']        = 'www-data'
  default['php']['fpm_listen_user']  = 'www-data'
  default['php']['fpm_listen_group'] = 'www-data'

  if platform?('debian') && node['platform_version'].to_i >= 10
    default['php']['version']          = '7.3.19'
    default['php']['checksum']         = '809126b46d62a1a06c2d5a0f9d7ba61aba40e165f24d2d185396d0f9646d3280'
    default['php']['conf_dir']         = '/etc/php/7.3/cli'
    default['php']['src_deps']         = %w(libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-turbo-dev libkrb5-dev libmcrypt-dev libpng-dev libssl-dev pkg-config libxml2-dev file re2c libzip-dev)
    # Debian >= 10 drops versions from the package names
    default['php']['packages']         = %w(php-cgi php php-dev php-cli php-pear)
    default['php']['fpm_package']      = 'php7.3-fpm'
    default['php']['fpm_pooldir']      = '/etc/php/7.3/fpm/pool.d'
    default['php']['fpm_service']      = 'php7.3-fpm'
    default['php']['fpm_socket']       = '/var/run/php/php7.3-fpm.sock'
    default['php']['fpm_default_conf'] = '/etc/php/7.3/fpm/pool.d/www.conf'
    default['php']['fpm_conf_dir']     = '/etc/php/7.3/fpm'
    default['php']['ext_conf_dir']     = '/etc/php/7.3/mods-available'
  elsif platform?('ubuntu') && node['platform_version'].to_f == 18.04
    default['php']['version']          = '7.2.31'
    default['php']['checksum']         = '796837831ccebf00dc15921ed327cfbac59177da41b33044d9a6c7134cdd250c'
    default['php']['conf_dir']         = '/etc/php/7.2/cli'
    default['php']['src_deps']         = %w(libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-dev libkrb5-dev libmcrypt-dev libpng-dev libssl-dev pkg-config libxml2-dev)
    default['php']['packages']         = %w(php7.2-cgi php7.2 php7.2-dev php7.2-cli php-pear)
    default['php']['fpm_package']      = 'php7.2-fpm'
    default['php']['fpm_pooldir']      = '/etc/php/7.2/fpm/pool.d'
    default['php']['fpm_service']      = 'php7.2-fpm'
    default['php']['fpm_socket']       = '/var/run/php/php7.2-fpm.sock'
    default['php']['fpm_default_conf'] = '/etc/php/7.2/fpm/pool.d/www.conf'
    default['php']['fpm_conf_dir']     = '/etc/php/7.2/fpm'
    default['php']['ext_conf_dir']     = '/etc/php/7.2/mods-available'
  elsif platform?('ubuntu') && node['platform_version'].to_f >= 20.04
    default['php']['version']          = '7.4.7'
    default['php']['checksum']         = 'a554a510190e726ebe7157fb00b4aceabdb50c679430510a3b93cbf5d7546e44'
    default['php']['conf_dir']         = '/etc/php/7.4/cli'
    default['php']['src_deps']         = %w(libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-dev libkrb5-dev libmcrypt-dev libpng-dev libssl-dev pkg-config libxml2-dev libsqlite3-dev libonig-dev)
    default['php']['packages']         = %w(php7.4-cgi php7.4 php7.4-dev php7.4-cli php-pear)
    default['php']['fpm_package']      = 'php7.4-fpm'
    default['php']['fpm_pooldir']      = '/etc/php/7.4/fpm/pool.d'
    default['php']['fpm_service']      = 'php7.4-fpm'
    default['php']['fpm_socket']       = '/var/run/php/php7.4-fpm.sock'
    default['php']['fpm_default_conf'] = '/etc/php/7.4/fpm/pool.d/www.conf'
    default['php']['fpm_conf_dir']     = '/etc/php/7.4/fpm'
    default['php']['enable_mod']       = '/usr/sbin/phpenmod'
    default['php']['disable_mod']      = '/usr/sbin/phpdismod'
    default['php']['ext_conf_dir']     = '/etc/php/7.4/mods-available'
  end
end

default['php']['src_recompile'] = false

default['php']['configure_options'] = %W(--prefix=#{node['php']['prefix_dir']}
                                         --with-libdir=#{lib_dir}
                                         --with-config-file-path=#{node['php']['conf_dir']}
                                         --with-config-file-scan-dir=#{node['php']['ext_conf_dir']}
                                         --with-pear
                                         --enable-fpm
                                         --with-fpm-user=#{node['php']['fpm_user']}
                                         --with-fpm-group=#{node['php']['fpm_group']}
                                         --with-zlib
                                         --with-openssl
                                         --with-kerberos
                                         --with-bz2
                                         --with-curl
                                         --enable-ftp
                                         --enable-zip
                                         --enable-exif
                                         --with-gd
                                         --enable-gd-native-ttf
                                         --with-gettext
                                         --with-gmp
                                         --with-mhash
                                         --with-iconv
                                         --with-imap
                                         --with-imap-ssl
                                         --enable-sockets
                                         --enable-soap
                                         --with-xmlrpc
                                         --with-mcrypt
                                         --enable-mbstring)
