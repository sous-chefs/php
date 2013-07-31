php_pear "mongo" do
  action :install
end

script "install_program" do
  not_if {File.exists?('/etc/php5/conf.d/mongo.ini')}
  interpreter "bash"
  user "root"
  code <<-EOH
    echo "extension=mongo.so" > /etc/php5/conf.d/mongo.ini
  EOH
end

