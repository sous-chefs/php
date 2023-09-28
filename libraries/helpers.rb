# frozen_string_literal: true

module Php
  module Cookbook
    module Helpers
      def php_lib_dir
        arch = node['kernel']['machine']

        case node['platform_family']
        when 'rhel', 'amazon'
          if arch =~ /x86_64/
            'lib64/php'
          else
            'lib/php'
          end
        when 'debian'
          'lib'
        end
      end

      def php_conf_dir
        case node['platform_family']
        when 'rhel', 'amazon'
          '/etc'
        when 'debian'
          case node['platform']
          when 'debian'
            case node['platform_version'].to_i
            when 10
              '/etc/php/7.3/cli'
            else # >= 11
              '/etc/php/7.4/cli'
            end
          when 'ubuntu'
            case node['platform_version'].to_f
            when 18.04
              '/etc/php/7.2/cli'
            when 20.04
              '/etc/php/7.4/cli'
            else # >= 22.04
              '/etc/php/8.1/cli'
            end
          else
            '/etc/php/7.0/cli'
          end
        end
      end

      def php_disable_mod
        '/usr/sbin/phpdismod'
      end

      def php_enable_mod
        '/usr/sbin/phpenmod'
      end

      def php_ext_conf_dir
        case node['platform_family']
        when 'rhel', 'amazon'
          '/etc/php.d'
        when 'debian'
          case node['platform']
          when 'debian'
            case node['platform_version'].to_i
            when 10
              '/etc/php/7.3/mods-available'
            else # >= 11
              '/etc/php/7.4/mods-available'
            end
          when 'ubuntu'
            case node['platform_version'].to_f
            when 18.04
              '/etc/php/7.2/mods-available'
            when 20.04
              '/etc/php/7.4/mods-available'
            else # >= 22.04
              '/etc/php/8.1/mods-available'
            end
          else
            '/etc/php/7.0/mods-available'
          end
        end
      end

      def php_ext_dir
        case node['platform_family']
        when 'rhel', 'amazon'
          "/usr/#{php_lib_dir}/modules"
        when 'debian'
          "/usr/#{php_lib_dir}/php/#{php_version}/modules"
        end
      end

      def php_fpm_conf_dir
        case node['platform_family']
        when 'rhel', 'amazon'
          '/etc/php-fpm.d'
        when 'debian'
          case node['platform']
          when 'debian'
            case node['platform_version'].to_i
            when 10
              '/etc/php/7.3/fpm'
            else # >= 11
              '/etc/php/7.4/fpm'
            end
          when 'ubuntu'
            case node['platform_version'].to_f
            when 18.04
              '/etc/php/7.2/fpm'
            when 20.04
              '/etc/php/7.4/fpm'
            else # >= 22.04
              '/etc/php/8.1/fpm'
            end
          else
            '/etc/php/7.0/fpm'
          end
        end
      end

      def php_fpm_default_conf
        case node['platform_family']
        when 'rhel', 'amazon'
          '/etc/php-fpm.d/www.conf'
        when 'debian'
          case node['platform']
          when 'debian'
            case node['platform_version'].to_i
            when 10
              '/etc/php/7.3/fpm/pool.d/www.conf'
            else # >= 11
              '/etc/php/7.4/fpm/pool.d/www.conf'
            end
          when 'ubuntu'
            case node['platform_version'].to_f
            when 18.04
              '/etc/php/7.2/fpm/pool.d/www.conf'
            when 20.04
              '/etc/php/7.4/fpm/pool.d/www.conf'
            else # >= 22.04
              '/etc/php/8.1/fpm/pool.d/www.conf'
            end
          else
            '/etc/php/7.0/fpm/pool.d/www.conf'
          end
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
        case node['platform_family']
        when 'rhel', 'amazon'
          'php-fpm'
        when 'debian'
          case node['platform']
          when 'debian'
            case node['platform_version'].to_i
            when 10
              'php7.3-fpm'
            else # >= 11
              'php7.4-fpm'
            end
          when 'ubuntu'
            case node['platform_version'].to_f
            when 18.04
              'php7.2-fpm'
            when 20.04
              'php7.4-fpm'
            else # >= 22.04
              'php8.1-fpm'
            end
          else
            'php7.0-fpm'
          end
        end
      end

      def php_fpm_pool_dir
        case node['platform_family']
        when 'rhel', 'amazon'
          '/etc/php-fpm.d'
        when 'debian'
          case node['platform']
          when 'debian'
            case node['platform_version'].to_i
            when 10
              '/etc/php/7.3/fpm/pool.d'
            else # >= 11
              '/etc/php/7.4/fpm/pool.d'
            end
          when 'ubuntu'
            case node['platform_version'].to_f
            when 18.04
              '/etc/php/7.2/fpm/pool.d'
            when 20.04
              '/etc/php/7.4/fpm/pool.d'
            else # >= 22.04
              '/etc/php/8.1/fpm/pool.d'
            end
          else
            '/etc/php/7.0/fpm/pool.d'
          end
        end
      end

      def php_fpm_pool_cookbook
        'php'
      end

      def php_fpm_pool_template
        'fpm-pool.conf.erb'
      end

      def php_fpm_service
        case node['platform_family']
        when 'rhel', 'amazon'
          'php-fpm'
        when 'debian'
          case node['platform']
          when 'debian'
            case node['platform_version'].to_i
            when 10
              'php7.3-fpm'
            else # >= 11
              'php7.4-fpm'
            end
          when 'ubuntu'
            case node['platform_version'].to_f
            when 18.04
              'php7.2-fpm'
            when 20.04
              'php7.4-fpm'
            else # >= 22.04
              'php8.1-fpm'
            end
          else
            'php7.0-fpm'
          end
        end
      end

      def php_fpm_socket
        case node['platform_family']
        when 'rhel', 'amazon'
          '/var/run/php7.2-fpm.sock'
        when 'debian'
          case node['platform']
          when 'debian'
            case node['platform_version'].to_i
            when 10
              '/var/run/php/php7.3-fpm.sock'
            else # >= 11
              '/var/run/php/php7.4-fpm.sock'
            end
          when 'ubuntu'
            case node['platform_version'].to_f
            when 18.04
              '/var/run/php/php7.2-fpm.sock'
            when 20.04
              '/var/run/php/php7.4-fpm.sock'
            else # >= 22.04
              '/var/run/php/php8.1-fpm.sock'
            end
          else
            '/var/run/php/php7.0-fpm.sock'
          end
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
          %w(php8.2 php8.2-devel php8.2-cli php-pear)
        when 'debian'
          case node['platform']
          when 'debian'
            %w(php-cgi php php-dev php-cli php-pear)
          when 'ubuntu'
            case node['platform_version'].to_f
            when 18.04
              %w(php7.2-cgi php7.2 php7.2-dev php7.2-cli php-pear)
            when 20.04
              %w(php7.4-cgi php7.4 php7.4-dev php7.4-cli php-pear)
            else # >= 22.04
              %w(php8.1-cgi php8.1 php8.1-dev php8.1-cli php-pear)
            end
          else
            %w(php7.0-cgi php7.0 php7.0-dev php7.0-cli php-pear)
          end
        end
      end

      def php_pecl
        'pecl'
      end

      def php_version
        case node['platform_family']
        when 'rhel', 'amazon'
          '7.2.31'
        when 'debian'
          case node['platform']
          when 'debian'
            case node['platform_version'].to_i
            when 10
              '7.3.19'
            else
              '7.4.27' # >= 11
            end
          when 'ubuntu'
            case node['platform_version'].to_f
            when 18.04
              '7.2.31'
            when 20.04
              '7.4.7'
            else # >= 22.04
              '8.1.7'
            end
          else
            '7.0.4'
          end
        end
      end
    end
  end
end
