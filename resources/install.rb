unified_mode true
include Php::Cookbook::Helpers

property :packages, Array, default: lazy { php_installation_packages }
property :community_package, [true, false], default: false
property :source, [true, false], default: false
# property :options
# property :fpm_ini_control

action :install do
  package 'Install PHP Packages' do
    package_name new_resource.packages

    if new_resource.community_package
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
    end

    # include_recipe 'php::package'
      # package node['php']['packages'] do
        # options node['php']['package_options']
      # end
      # include_recipe 'php::ini'
  else if new_resource.source
    if platform?('debian') && node['platform_version'].to_i == 9
      Chef::Log.fatal 'Debian 9 is not supported when building from source'
    end
    ext_dir_prefix = php_ext_dir ? "EXTENSION_DIR=#{php_ext_dir}" : ''

    php_exists = if new_resource.src_recompile
                   false
                 else
                   "$(which #{php_bin}) --version | grep #{new_resource.version}"
                 end
    build_essential

    include_recipe 'yum-epel' if platform_family?('rhel', 'amazon')

    package 'Install PHP Source Dependencies' do
      package_name new_resource.src_deps
      action :install
    end

    log "php_exists == #{php_exists}"

    remote_file "#{Chef::Config[:file_cache_path]}/php-#{new_resource.version}.tar.gz" do
      source "#{new_resource.url}/php-#{new_resource.version}.tar.gz"
      checksum new_resource.checksum
      action :create_if_missing
      not_if php_exists
      notifies :run, 'execute[un-pack php]', :immediately
    end

    execute 'un-pack php' do
      cwd Chef::Config[:file_cache_path]
      command "tar -zxf php-#{new_resource.version}.tar.gz"
      creates "#{Chef::Config[:file_cache_path]}/php-#{new_resource.version}"
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
      cwd "#{Chef::Config[:file_cache_path]}/php#{new_resource.version}"
      command 'make clean'
      only_if { new_resource.src_recompile }
    end

    execute 'configure php' do
      cwd "#{Chef::Config[:file_cache_path]}/php-#{new_resource.version}"
      command "#{ext_dir_prefix} ./configure #{new_resource.configure_options.join(' ')}"
      not_if php_exists
    end

    execute 'build and install php' do
      cwd "#{Chef::Config[:file_cache_path]}/php-#{new_resource.version}"
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

  end

  php_config 'php-config' do
    action :install
  end
end

action_class do
  include Php::Cookbook::Helpers
end
