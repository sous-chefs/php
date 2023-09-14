unified_mode true
include Php::Cookbook::Helpers

property :fpm_service, String, default: lazy { php_fpm_service }
property :fpm_ini_control, [true, false], default: false
property :ini_template, String, default: 'php.ini.erb'
property :ini_cookbook, String, default: 'php'
property :directives, Hash, default: {}

action :install do
  if new_resource.fpm_ini_control

    service new_resource.fpm_service do
      action :enable
    end

    template "#{php_fpm_conf_dir}/php.ini" do
      source new_resource.ini_template
      cookbook new_resource.ini_cookbook
      owner 'root'
      group node['root_group']
      mode '0644'
      manage_symlike_source true
      variables(directives: new_resource.directives)
      notifies :restart, "service[#{new_resource.fpm_service}]"
      not_if { new_resource.fpm_conf_dir.nil? }
    end
  end

  template "#{new_resource.conf_dir}/php.ini" do
    source new_resource.ini_template
    cookbook new_resource.ini_cookbook
    owner 'root'
    group node['root_group']
    mode '0644'
    manage_symlink_source true
    variables(directives: new_resource.directives)
  end
end

action_class do
  include Php::Cookbook::Helpers
end
