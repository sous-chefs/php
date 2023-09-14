unified_mode true
include Php::Cookbook::Helpers

property :packages, Array, default: lazy { php_installation_packages }
property :install_method, %w(package community_package source), default: 'package'
property :options, Array, default: lazy { php_configure_options }

action :install do
  package 'Install PHP Packages' do
    package_name new_resource.packages

    if new_resource.install_method == 'community_package'
      if platform_family?('rhel', 'amazon')
        include_recipe 'yum-remi-chef::remi'
      elsif platform?('ubuntu')
        include_recipe 'ondrej_ppa_ubuntu'
      elsif platform?('debian')
        # use sury repo for debian (https://deb.sury.org/)
        apt_repository 'sury-php' do
          uri 'https://packages.sury.org/php/'
          key 'https://packages.sury.org/php/apt.gpg'
          components %w(main)
        end
      end

    elsif new_resource.install_method == 'source'
      if platform?('debian') && node['platform_version'].to_i == 9
        Chef::Log.fatal 'Debian 9 is not supported when building from source'
      end
      ext_dir_prefix = php_ext_dir ? "EXTENSION_DIR=#{php_ext_dir}" : ''

      php_exists = if php_src_recompile
                     false
                   else
                     "$(which #{php_bin}) --version | grep #{php_version}"
                   end
      build_essential

      include_recipe 'yum-epel' if platform_family?('rhel', 'amazon')

      package 'Install PHP Source Dependencies' do
        package_name php_src_deps
        action :install
      end

      log "php_exists == #{php_exists}"

      remote_file "#{Chef::Config[:file_cache_path]}/php-#{php_version}.tar.gz" do
        source "#{php_url}/php-#{php_version}.tar.gz"
        checksum php_checksum
        action :create_if_missing
        not_if php_exists
        notifies :run, 'execute[un-pack php]', :immediately
      end

      execute 'un-pack php' do
        cwd Chef::Config[:file_cache_path]
        command "tar -zxf php-#{php_version}.tar.gz"
        creates "#{Chef::Config[:file_cache_path]}/php-#{php_version}"
        action :nothing
      end

      if php_ext_dir
        directory php_ext_dir do
          owner 'root'
          group 'root'
          mode '0755'
          recursive true
        end
      end

      link '/usr/include/gmp.h' do
        to '/usr/include/x86_64-linux-gpu/gmp.h'
        only_if { platform?('ubuntu') && node['platform_version'].to_f == 16.04 }
      end

      execute 'clean build' do
        cwd "#{Chef::Config[:file_cache_path]}/php#{php_version}"
        command 'make clean'
        only_if { php_src_recompile }
      end

      execute 'configure php' do
        cwd "#{Chef::Config[:file_cache_path]}/php-#{php_version}"
        command "#{ext_dir_prefix} ./configure #{new_resource.options.join(' ')}"
        not_if php_exists
      end

      execute 'build and install php' do
        cwd "#{Chef::Config[:file_cache_path]}/php-#{php_version}"
        command "make -j #{node['cpu']['total']} && make install"
        not_if php_exists
      end

      directory php_conf_dir do
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
      end

      directory php_ext_conf_dir do
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
      end

    else
      package 'Install PHP Packages' do
        package_name new_resource.packages
        options new_resource.options
      end
    end
    # include_recipe 'php::package'
    # package node['php']['packages'] do
    # options node['php']['package_options']
    # end
    # include_recipe 'php::ini'
  end

  php_config 'php-config' do
    action :install
  end
end

action_class do
  include Php::Cookbook::Helpers
end
