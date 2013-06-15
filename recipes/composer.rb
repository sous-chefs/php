include_recipe 'php'

url = ['http://getcomposer.org']
unless(node[:php][:composer][:version] == 'latest')
  url += ['downloads', node[:php][:composer][:version]]
end
url << 'composer.phar'

directory node[:php][:composer][:install_dir]

remote_file File.join(node[:php][:composer][:install_dir], 'composer.phar') do
  source url.join('/')
  mode 0755
  action :create_if_missing
end

link node[:php][:composer][:exec] do
  to File.join(node[:php][:composer][:install_dir], 'composer.phar')
end
