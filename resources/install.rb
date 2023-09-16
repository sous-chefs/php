unified_mode true
include Php::Cookbook::Helpers

property :packages, Array, default: lazy { php_installation_packages }
property :install_method, %w(package community_package source), default: 'package'
# property :recompile, [true, false], default: false
property :options, [ String, Array ]

action :install do
  package 'Install PHP Packages' do
    package_name new_resource.packages
    options new_resource.options
  end

  php_ini 'ini'
end
