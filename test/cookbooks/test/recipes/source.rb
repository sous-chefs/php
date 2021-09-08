apt_update 'update'

node.default['php']['install_method'] = 'source'
node.default['php']['pear'] = '/usr/local/bin/pear'
node.default['php']['url'] = 'https://ftp.osuosl.org/pub/php/' # the default site blocks github actions boxes

include_recipe 'php'
