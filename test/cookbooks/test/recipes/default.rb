apt_update 'update'

include_recipe 'php'

# create a test pool
php_fpm_pool 'test-pool' do
  action :install
end
