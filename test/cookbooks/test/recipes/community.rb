::Chef::DSL::Recipe.include Php::Cookbook::Helpers

php_install 'php' do
  install_type 'package'
  community_package true
end

apt_update 'update'

# Create a test pool
php_fpm_pool 'test-pool' do
  action :install
end

# Add PEAR channel
php_pear_channel 'pear.php.net' do
  binary php_pear_path
  action :update
end

# Install https://pear.php.net/package/HTTP2
php_pear 'HTTP2' do
  binary php_pear_path
end

# Add PECL channel
php_pear_channel 'pecl.php.net' do
  binary php_pear_path
  action :update
end

# Install https://pecl.php.net/package/sync
php_pear 'sync-binary' do
  package_name 'sync'
  binary 'pecl'
  priority '50'
end
