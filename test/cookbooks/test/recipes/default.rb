apt_update 'update'

php_install 'php'

# Create a test pool
php_fpm_pool 'test-pool'

# Add PEAR channel
php_pear_channel 'pear.php.net' do
  action :update
end

# Install https://pear.php.net/package/HTTP2
php_pear 'HTTP2'

# Add PECL channel
php_pear_channel 'pecl.php.net' do
  action :update
end

if platform?('fedora')
  Chef::Log.warn 'Skipping PECL sync on Fedora: sync 1.1.3 does not build against Fedora latest PHP 8.5 headers'
else
  # Install https://pecl.php.net/package/sync
  pecl_method = node['pecl_method'] || 'binary'
  php_pear "sync-#{pecl_method}" do
    package_name 'sync'
    binary 'pecl' if pecl_method == 'binary'
    channel 'pecl.php.net' if pecl_method == 'channel'
    priority '50'
  end
end
