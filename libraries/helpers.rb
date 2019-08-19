module Php
  module Helpers
    def default_fpm_socket(php_version)
      "/var/run/php/php#{php_version}-fpm.sock"
    end

    def default_fpm_user
      case node['platform_family']
      when 'rhel', 'fedora', 'amazon'
        'nobody'
      when 'debian'
        'www-data'
      when 'suse'
        'wwwrun'
      when 'freebsd'
        'www'
      end
    end

    def default_fpm_group
      if node['platform_family'] == 'suse'
        'www'
      else
        default_fpm_user
      end
    end

    def default_fpm_listen_user
      default_fpm_user
    end

    def default_fpm_listen_group
      default_fpm_group
    end

    def default_php_lib_dir
      case node['platform_family']
      when 'rhel', 'fedora', 'amazon'
        node['kernel']['machine'] =~ /x86_64/ ? 'lib64' : 'lib'
      else
        'lib'
      end
    end
  end
end
