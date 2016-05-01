include_recipe 'apt'
include_recipe 'php'

# update the main pear channel
php_pear_channel 'pear.php.net' do
  action :update
end

# create a test pool
php_fpm_pool 'test-pool' do
  action :install
end
