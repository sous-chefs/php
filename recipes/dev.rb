template "/bin/php-dev" do
    mode 0775
    source "php-dev.erb"
    variables({
        :parameters => node['php']['dev']
    })
    action :create
end