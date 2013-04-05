# - 2013 paigeadele (paigeadele@gmail.com)

package "libev-dev"

git "#{Chef::Config[:file_cache_path]}/phpcouchbase" do
  repository node['php_couchbase_module']['ext_git_repo']
  reference node['php_couchbase_module']['ext_git_branch']
  action :sync
end

git "#{Chef::Config[:file_cache_path]}/libcouchbase" do
  repository node['php_couchbase_module']['lib_git_repo']
  reference node['php_couchbase_module']['lib_git_branch']
  action :sync
end

link "/usr/src/phpcouchbase" do
  to "#{Chef::Config[:file_cache_path]}/phpcouchbase"
end

link "/usr/src/libcouchbase" do
  to "#{Chef::Config[:file_cache_path]}/libcouchbase"
end

bash "install_libcouchbase" do
  cwd "#{Chef::Config[:file_cache_path]}/libcouchbase"
  code <<-EOF
    (config/autorun.sh)
    (./configure --prefix=/usr/local/libcouchbase --disable-couchbasemock)
    (make && make install)
  EOF
  only_if { node['php']['build'] }
end

bash "install_couchbase_ext" do
  cwd "#{Chef::Config[:file_cache_path]}/phpcouchbase"
  code <<-EOF
    (#{node['php']['prefix_dir']}/bin/phpize)
    (./configure --with-couchbase=/usr/local/libcouchbase --with-php-config=#{node['php']['prefix_dir']}/bin/php-config)
    (make && make install)
  EOF
  only_if { node['php']['build'] }
end
