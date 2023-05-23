yum_remi_php80 'default' if platform_family?('rhel', 'amazon')

php_install 'php' do
  if platform_family?('rhel', 'amazon')
    packages %w(php80 php80-php-devel php80-php-cli php80-php-pear)
  end
  communityPackages true
  action :install
end

apt_update 'update'

# README: The Remi repo intentionally avoids installing the binaries to
#         the default paths. It comes with a /opt/remi/php80/enable profile
#         which can be copied or linked into /etc/profiles.d to auto-load for
#         operators in a real cookbook.
# if platform_family?('rhel', 'amazon')
#   link '/usr/bin/php' do
#     to '/usr/bin/php80'
#   end
#
#   link '/usr/bin/pear' do
#     to '/usr/bin/php80-pear'
#   end
#
#   link '/usr/bin/pecl' do
#     to '/opt/remi/php80/root/bin/pecl'
#   end
#
#   link '/etc/profile.d/php80-enable.sh' do
#     to '/opt/remi/php80/enable'
#   end
# end

# Create a test pool
php_fpm_pool 'test-pool' do
  listen '/var/run/php-test-fpm.sock'
  pool_dir '/etc/opt/remi/php80/php-fpm.d'
  fpm_package 'php80-php-fpm'
  service 'php80-php-fpm'
  default_conf '/etc/opt/remi/php80/php-fpm.d/www.conf'
end

# Add PEAR channel
php_pear_channel 'pear.php.net' do
  binary 'php80-pear'
end

# Install https://pear.php.net/package/HTTP2
php_pear 'HTTP2' do
  binary 'php80-pear'
end

# Add PECL channel
php_pear_channel 'pecl.php.net' do
  binary 'php80-pear'
end

# Install https://pecl.php.net/package/sync
pecl_method = node['pecl_method'] || 'binary'
php_pear "sync-#{pecl_method}" do
  package_name 'sync'
  pecl '/opt/remi/php80/root/bin/pecl'
  binary 'pecl' if pecl_method == 'binary'
  channel 'pecl.php.net' if pecl_method == 'channel'
  priority '50'
  conf_dir '/etc/opt/remi/php80'
  ext_conf '/etc/opt/remi/php80/php.d'
end
