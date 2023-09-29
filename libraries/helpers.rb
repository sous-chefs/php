module Php
  module Cookbook
    module Helpers
      def php_conf_dir
        if platform_family?('rhel', 'amazon')
          '/etc'
        else
          "/etc/php/#{php_version}/cli"
        end
      end

      def php_disable_mod
        '/usr/sbin/phpdismod'
      end

      def php_enable_mod
        '/usr/sbin/phpenmod'
      end

      def php_ext_conf_dir
        if platform_family?('rhel', 'amazon')
          '/etc/php.d'
        else
          "/etc/php/#{php_version}/mods-available"
        end
      end

      def php_ext_dir
        '/usr/lib64/php/modules'
      end

      def php_fpm_conf_dir
        if platform_family?('rhel', 'amazon')
          '/etc/php-fpm.d'
        else
          "/etc/php/#{php_version}/fpm"
        end
      end

      def php_fpm_default_conf
        if platform_family?('rhel', 'amazon')
          '/etc/php-fpm.d/www.conf'
        else
          "/etc/php/#{php_version}/fpm/pool.d/www.conf"
        end
      end

      def php_fpm_group
        case node['platform_family']
        when 'rhel', 'amazon'
          'apache'
        when 'debian'
          'www-data'
        end
      end

      def php_fpm_listen_group
        case node['platform_family']
        when 'rhel', 'amazon'
          'apache'
        when 'debian'
          'www-data'
        end
      end

      def php_fpm_listen_user
        case node['platform_family']
        when 'rhel', 'amazon'
          'apache'
        when 'debian'
          'www-data'
        end
      end

      def php_fpm_package
        if platform_family?('rhel', 'amazon')
          'php-fpm'
        else
          "php#{php_version}-fpm"
        end
      end

      def php_fpm_pool_dir
        if platform_family?('rhel', 'amazon')
          '/etc/php-fpm.d'
        else
          "/etc/php/#{php_version}/fpm/pool.d"
        end
      end

      def php_fpm_pool_cookbook
        'php'
      end

      def php_fpm_pool_template
        'fpm-pool.conf.erb'
      end

      def php_fpm_service
        if platform_family?('rhel', 'amazon')
          'php-fpm'
        else
          "php#{php_version}-fpm"
        end
      end

      def php_fpm_socket
        if platform_family?('rhel', 'amazon')
          "/var/run/php#{php_version}-fpm.sock"
        else
          "/var/run/php/php#{php_version}-fpm.sock"
        end
      end

      def php_fpm_user
        case node['platform_family']
        when 'rhel', 'amazon'
          'apache'
        when 'debian'
          'www-data'
        end
      end

      def php_ini_template
        'php.ini.erb'
      end

      def php_ini_cookbook
        'php'
      end

      def php_installation_packages
        case node['platform_family']
        when 'rhel'
          %w(php php-devel php-cli php-pear)
        # Sometimes Amazon will default to different versions for each package,
        # so versions are pinned here to avoid packages getting ahead of each
        # other
        when 'amazon'
          ["php#{php_version}", "php#{php_version}-devel", "php#{php_version}-cli", 'php-pear']
        when 'debian'
          case node['platform']
          when 'debian'
            %w(php-cgi php php-dev php-cli php-pear)
          when 'ubuntu'
            ["php#{php_version}-cgi", "php#{php_version}", "php#{php_version}-dev", "php#{php_version}-cli", 'php-pear']
          end
        end
      end

      def php_pecl
        'pecl'
      end

      def php_version
        case node['platform_family']
        when 'rhel'
          '7.2'
        when 'amazon'
          '8.2'
        when 'debian'
          case node['platform']
          when 'debian'
            case node['platform_version'].to_i
            when 10
              '7.3'
            else
              '7.4' # >= 11
            end
          when 'ubuntu'
            case node['platform_version'].to_f
            when 18.04
              '7.2'
            when 20.04
              '7.4'
            else # >= 22.04
              '8.1'
            end
          else
            '7.0'
          end
        end
      end
    end
  end
end

Chef::DSL::Recipe.include Php::Cookbook::Helpers
Chef::Resource.include Php::Cookbook::Helpers
