template "#{node['php']['conf_dir']}/php.ini" do
  source node['php']['ini']['template']
  cookbook node['php']['ini']['cookbook']
  owner 'root'
  group node['root_group']
  mode '0644'
  manage_symlink_source true
  variables(directives: node['php']['directives'])
end
