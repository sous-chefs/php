unified_mode true
include Php::Cookbook::Helpers

property :conf_dir, String, default: lazy { php_conf_dir }
property :ini_template, String, default: lazy { php_ini_template }
property :ini_cookbook, String, default: lazy { php_ini_cookbook }
property :directives, Hash, default: {}
property :ext_dir, String, default: lazy { php_ext_dir }

action :add do
  template "#{new_resource.conf_dir}/php.ini" do
    source new_resource.ini_template
    cookbook new_resource.ini_cookbook
    owner 'root'
    group 'root'
    mode '0644'
    manage_symlink_source true
    variables(
      directives: new_resource.directives,
      php_ext_dir: new_resource.ext_dir
    )
  end
end

action :remove do
  file "#{new_resource.conf_dir}/php.ini" do
    action :delete
  end
end
