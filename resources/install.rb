unified_mode true
include Php::Cookbook::Helpers

property :packages, Array, default: lazy { php_installation_packages }
property :options, [ String, Array ]

property :conf_dir, String, default: lazy { php_conf_dir }
property :ini_template, String, default: lazy { php_ini_template }
property :ini_cookbook, String, default: lazy { php_ini_cookbook }
property :directives, Hash, default: {}
property :ext_dir, String, default: lazy { php_ext_dir }

action :install do
  package 'Install PHP Packages' do
    package_name new_resource.packages
    options new_resource.options
  end

  php_ini 'ini' do
    conf_dir new_resource.conf_dir
    ini_template new_resource.ini_template
    ini_cookbook new_resource.ini_cookbook
    directives new_resource.directives
    ext_dir new_resource.ext_dir
  end
end
