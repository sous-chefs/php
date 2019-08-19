php_install node['php']['install_method']

# update the main channels
node['php']['pear_channels'].each do |channel|
  php_pear_channel channel do
    binary node['php']['pear']
    action :update
    only_if { node['php']['pear_setup'] }
  end
end

include_recipe 'php::ini'
