version = node['php']['version']
configure_options = node['php']['configure_options'].join(' ')
ext_dir_prefix = node['php']['ext_dir'] ? "EXTENSION_DIR=#{node['php']['ext_dir']}" : ''

node['php']['src_deps'].each do |pkg|
  package pkg do
    action 'install'
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/php-#{version}.tar.gz" do
  source "#{node['php']['url']}/php-#{version}.tar.gz/from/this/mirror"
  checksum node['php']['checksum']
  mode '0644'
  action 'create_if_missing'
end

bash 'un-pack php' do
  cwd Chef::Config[:file_cache_path]
  code "tar -zxf php-#{version}.tar.gz"
  creates "#{Chef::Config[:file_cache_path]}/php-#{version}"
end

bash 're-build php' do
  cwd "#{Chef::Config[:file_cache_path]}/php-#{version}"
  code <<-EOF
  (make clean)
  (#{ext_dir_prefix} ./configure #{configure_options})
  (make -j #{node['cpu']['total']} && make install)
  EOF
end
