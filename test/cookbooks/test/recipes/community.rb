yum_remi_php80 'default' if platform_family?('rhel', 'amazon')

if platform_family?('debian')
  packages %w(php8.2 php8.2-cgi php8.2-cli php8.2-dev php-pear)
  php_conf_dir         = '/etc/php/8.2/'
  php_ext_conf_dir     = '/etc/php/8.2/mods-available'
  php_fpm_package      = 'php8.2-fpm'
  php_fpm_service      = 'php8.2-fpm'
  php_fpm_conf_dir     = '/etc/php/8.2/fpm'
  php_fpm_pooldir      = '/etc/php/8.2/fpm/pool.d'
  php_fpm_default_conf = '/etc/php/8.2/fpm/pool.d/www.conf'
  php_fpm_socket       = '/var/run/php/php8.2-fpm.sock'
end

php_install 'php' do
  if platform_family?('rhel', 'amazon')
    packages %w(php80 php80-php-devel php80-php-cli php80-php-pear)
  end
  community_package true
  action :install
end

apt_update 'update'

# README: The Remi repo intentionally avoids installing the binaries to
#         the default paths. It comes with a /opt/remi/php80/enable profile
#         which can be copied or linked into /etc/profiles.d to auto-load for
#         operators in a real cookbook.
if platform_family?('rhel', 'amazon')
  link '/usr/bin/php' do
    to '/usr/bin/php80'
  end

  link '/usr/bin/pear' do
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
  if platform_family?('rhel', 'amazon')
    listen '/var/run/php-test-fpm.sock'
    pool_dir '/etc/opt/remi/php80/php-fpm.d'
    fpm_package 'php80-php-fpm'
    service 'php80-php-fpm'
    default_conf '/etc/opt/remi/php80/php-fpm.d/www.conf'
  end
  action :install
end

# Add PEAR channel
php_pear_channel 'pear.php.net' do
  if platform_family?('rhel', 'amazon')
    binary 'php80-pear'
  else
    binary '/usr/bin/pear'
  end
  action :update
end

# Install https://pear.php.net/package/HTTP2
php_pear 'HTTP2' do
  if platform_family?('rhel', 'amazon')
    binary 'php80-pear'
  else
    binary '/usr/bin/pear'
  end
end

# Add PECL channel
php_pear_channel 'pecl.php.net' do
  if platform_family?('rhel', 'amazon')
    binary 'php80-pear'
  else
    binary '/usr/bin/pear'
  end
  action :update
end

# Install https://pecl.php.net/package/sync
php_pear 'sync-binary' do
  if platform_family?('rhel', 'amazon')
    conf_dir '/etc/opt/remi/php80'
    ext_conf '/etc/opt/remi/php80/php.d'
  end
  package_name 'sync'
  binary 'pecl'
  priority '50'
end
