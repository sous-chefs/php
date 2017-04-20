apt_update 'update'

node.override['php']['install_method'] = 'source'

include_recipe 'php'
