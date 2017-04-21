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
