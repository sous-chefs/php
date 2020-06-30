apt_update

node.default['php']['install_method'] = 'source'
node.default['php']['pear'] = '/usr/local/bin/pear'

include_recipe 'php'
