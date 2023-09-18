unified_mode true
include Php::Cookbook::Helpers

property :fpm_ini_control, [true, false], default: false
property :fpm_service, String, default: lazy { php_fpm_service }
property :fpm_conf_dir, String, default: lazy { php_fpm_conf_dir }
property :ini_template, String, default: lazy { php_ini_template }
property :ini_cookbook, String, default: lazy { php_ini_cookbook }
property :directives, Hash, default: {}
property :ext_dir, String, default: lazy { php_ext_dir }
property :conf_dir, String, default: lazy { php_conf_dir }

action :install do
  if new_resource.fpm_ini_control

    # service new_resource.fpm_service do
    #   action :enable
    # end

    template "#{new_resource.fpm_conf_dir}/php.ini" do
      source new_resource.ini_template
      cookbook new_resource.ini_cookbook
      owner 'root'
      group node['root_group']
      mode '0644'
      manage_symlink_source true
      variables(
        directives: new_resource.directives,
        php_ext_dir: new_resource.ext_dir
      )
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
    variables(
      directives: new_resource.directives,
      php_ext_dir: new_resource.ext_dir
    )
  end
end
