# Test cookbook for the FPM LWRP

include_recipe 'apt'
include_recipe 'php'

php_fpm_pool 'test-pool' do
  action :install
end
