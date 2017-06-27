apt_update 'update'

include_recipe 'php'

# create a test pool
php_fpm_pool 'test-pool' do
  action :install
end

# add a channel
php_pear_channel 'pear.php.net' do
  action :update
end

# install a package from the pear.php.net channel
# http://pear.php.net/package/HTTP2
php_pear 'HTTP2'

php_pear 'Remove it now' do
  package_name 'HTTP2'
  action :remove
end

php_pear 'install the package again' do
  package_name 'HTTP2'
  action :install
end

php_pear 'reinstall the package' do
  package_name 'HTTP2'
  action :reinstall
end

php_pear 'Purge it now' do
  package_name 'HTTP2'
  action :purge
end
