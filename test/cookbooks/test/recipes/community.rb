node.default['php']['fpm_ini_control'] = false

if platform_family?('rhel', 'amazon')
  node.default['php']['packages']         = %w(php80 php80-php-devel php80-php-cli php80-php-pear)
  node.default['php']['conf_dir']         = '/etc/opt/remi/php80'
  node.default['php']['ext_conf_dir']     = '/etc/opt/remi/php80/php.d'
  node.default['php']['fpm_package']      = 'php80-php-fpm'
  node.default['php']['fpm_service']      = 'php80-php-fpm'
  node.default['php']['fpm_pooldir']      = '/etc/opt/remi/php80/php-fpm.d'
  node.default['php']['fpm_default_conf'] = '/etc/opt/remi/php80/php-fpm.d/www.conf'
  node.default['php']['pear']             = '/usr/bin/php80-pear'

  lib_dir = node['kernel']['machine'] =~ /x86_64/ ? 'lib64' : 'lib'
  node.default['php']['ext_dir'] = "/opt/remi/php80/root/#{lib_dir}/php/modules"
elsif platform_family?('debian')
  node.default['php']['packages']         = %w(php8.0 php8.0-cgi php8.0-cli php8.0-dev php-pear)
  node.default['php']['conf_dir']         = '/etc/php/8.0/'
  node.default['php']['ext_conf_dir']     = '/etc/php/8.0/mods-available'
  node.default['php']['fpm_package']      = 'php8.0-fpm'
  node.default['php']['fpm_service']      = 'php8.0-fpm'
  node.default['php']['fpm_conf_dir']     = '/etc/php/8.0/fpm'
  node.default['php']['fpm_pooldir']      = '/etc/php/8.0/fpm/pool.d'
  node.default['php']['fpm_default_conf'] = '/etc/php/8.0/fpm/pool.d/www.conf'
  node.default['php']['fpm_socket']       = '/var/run/php/php8.0-fpm.sock'
end

node.default['php']['install_method'] = 'community_package'

apt_update 'update'

include_recipe 'php'

# README: The Remi repo intentionally avoids installing the binaries to
#         the default paths. It comes with a /opt/remi/php80/enable profile
#         which can be copied or linked into /etc/profiles.d to auto-load for
#         operators in a real cookbook.
if platform_family?('rhel', 'amazon')
  link '/usr/bin/php' do
    to '/usr/bin/php80'
  end

  link '/usr/bin/php-pear' do
    to '/usr/bin/php80-pear'
  end

  link '/usr/bin/pecl' do
    to '/opt/remi/php80/root/bin/pecl'
  end

  link '/etc/profile.d/php80-enable.sh' do
    to '/opt/remi/php80/enable'
  end
end

# Create a test pool
php_fpm_pool 'test-pool' do
  action :install
end

# Add PEAR channel
php_pear_channel 'pear.php.net' do
  binary node['php']['pear']
  action :update
end

# Install https://pear.php.net/package/HTTP2
php_pear 'HTTP2' do
  binary node['php']['pear']
end

# Add PECL channel
php_pear_channel 'pecl.php.net' do
  binary node['php']['pear']
  action :update
end

# Install https://pecl.php.net/package/sync
php_pear 'sync-binary' do
  package_name 'sync'
  binary 'pecl'
  priority '50'
end
