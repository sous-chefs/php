apt_update 'update'

php_install 'php' do
  install_type 'source'
  url 'https://ftp.osuosl.org/pub/php/'
  action :install
end
