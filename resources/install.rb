unified_mode true
include Php::Cookbook::Helpers

property :packages, Array, default: lazy { php_installation_packages }
property :options, [ String, Array ]

property :fpm_ini_control, [true, false], default: false
property :fpm_service, String, default: lazy { php_fpm_service }
property :fpm_conf_dir, String, default: lazy { php_fpm_conf_dir }
property :ini_template, String, default: lazy { php_ini_template }
property :ini_cookbook, String, default: lazy { php_ini_cookbook }
property :directives, Hash, default: {}
property :ext_dir, String, default: lazy { php_ext_dir }
property :conf_dir, String, default: lazy { php_conf_dir }

action :install do
  package 'Install PHP Packages' do
    package_name new_resource.packages
    options new_resource.options
  end

  php_ini 'ini' do
    fpm_ini_control new_resource.fpm_ini_control
    fpm_service new_resource.fpm_service
    fpm_conf_dir new_resource.fpm_conf_dir
    ini_template new_resource.ini_template
    ini_cookbook new_resource.ini_cookbook
    directives new_resource.directives
    ext_dir new_resource.ext_dir
    conf_dir new_resource.conf_dir
  end
end
