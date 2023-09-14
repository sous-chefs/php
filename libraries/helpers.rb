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

      def php_bin
        'php'
      end

      def php_checksum
        case node['platform_family']
        when 'rhel', 'amazon'
          '796837831ccebf00dc15921ed327cfbac59177da41b33044d9a6c7134cdd250c'
        when 'debian'
          case node['platform']
          when 'debian'
            case node['platform_version'].to_i
            when 10
              '809126b46d62a1a06c2d5a0f9d7ba61aba40e165f24d2d185396d0f9646d3280'
            else # >= 11
              '564fd5bc9850370db0cb4058d9087f2f40177fa4921ce698a375416db9ab43ca'
            end
          when 'ubuntu'
            case node['platform_version'].to_f
            when 18.04
              '796837831ccebf00dc15921ed327cfbac59177da41b33044d9a6c7134cdd250c'
            when 20.04
              'a554a510190e726ebe7157fb00b4aceabdb50c679430510a3b93cbf5d7546e44'
            else # >= 22.04
              '5f0b422a117633c86d48d028934b8dc078309d4247e7565ea34b2686189abdd8'
            end
          else
            'f6cdac2fd37da0ac0bbcee0187d74b3719c2f83973dfe883d5cde81c356fe0a8'
          end
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

      def php_configure_options(install_method)
        %W(--prefix=#{php_prefix_dir}
           --with-libdir=#{php_lib_dir}
           --with-config-file-path=#{php_conf_dir}
           --with-config-file-scan-dir=#{php_ext_conf_dir}
           --with-pear
           --enable-fpm
           --with-fpm-user=#{php_fpm_user(install_method)}
           --with-fpm-group=#{php_fpm_group(install_method)}
           --with-zlib
           --with-openssl
           --with-kerberos
           --with-bz2
           --with-curl
           --enable-ftp
           --enable-zip
           --enable-exif
           --with-gd
           --enable-gd-native-ttf
           --with-gettext
           --with-gmp
           --with-mhash
           --with-iconv
           --with-imap
           --with-imap-ssl
           --enable-sockets
           --enable-soap
           --with-xmlrpc
           --with-mcrypt
           --enable-mbstring)
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

      def php_fpm_group(install_method)
        case node['platform_family']
        when 'rhel', 'amazon'
          if install_method == 'package'
            'apache'
          else
            'nobody'
          end
        when 'debian'
          'www-data'
        end
      end

      def php_fpm_listen_group(install_method)
        case node['platform_family']
        when 'rhel', 'amazon'
          if install_method == 'package'
            'apache'
          else
            'nobody'
          end
        when 'debian'
          'www-data'
        end
      end

      def php_fpm_listen_user(install_method)
        case node['platform_family']
        when 'rhel', 'amazon'
          if install_method == 'package'
            'apache'
          else
            'nobody'
          end
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

      def php_fpm_pooldir
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

      def php_fpm_user(install_method)
        case node['platform_family']
        when 'rhel', 'amazon'
          if install_method == 'package'
            'apache'
          else
            'nobody'
          end
        when 'debian'
          'www-data'
        end
      end

      def php_installation_packages
        case node['platform_family']
        when 'rhel', 'amazon'
          %w(php php-devel php-cli php-pear)
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

      def php_pear_path
        '/usr/bin/pear'
      end

      def php_pear_channels
        [
          'pear.php.net',
          'pecl.php.net',
        ]
      end

      def php_pear_setup
        true
      end

      def php_pecl
        'pecl'
      end

      def php_prefix_dir
        '/usr/local'
      end

      def php_src_deps
        case node['platform_family']
        when 'amazon'
          %w(bzip2-devel libc-client-devel libcurl-devel freetype-devel gmp-devel libjpeg-devel krb5-devel
             libmcrypt-devel libpng-devel openssl-devel t1lib-devel libxml2-devel libxslt-devel zlib-devel mhash-devel)
        when 'rhel'
          case node['platform_version'].to_i
          when 7
            %w(bzip2-devel libc-client-devel curl-devel freetype-devel gmp-devel libjpeg-devel krb5-devel
               libmcrypt-devel libpng-devel openssl-devel libxml2-devel libxslt-devel zlib-devel mhash-devel)
          else # >= 8
            %w(bzip2-devel libc-client-devel libcurl-devel freetype-devel gmp-devel libjpeg-devel krb5-devel
               libmcrypt-devel libpng-devel openssl-devel t1lib-devel libxml2-devel libxslt-devel zlib-devel mhash-devel)
          end
        when 'debian'
          case node['platform']
          when 'debian'
            case node['platform_version'].to_i
            when 10
              %w(libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-turbo-dev
                 libkrb5-dev libmcrypt-dev libpng-dev libssl-dev pkg-config libxml2-dev file re2c libzip-dev)
            else # >= 11
              %w(libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-turbo-dev
                 libkrb5-dev libmcrypt-dev libonig-dev libpng-dev libsqlite3-dev libssl-dev pkg-config libxml2-dev file re2c libzip-dev)
            end
          when 'ubuntu'
            case node['platform_version'].to_f
            when 18.04
              %w(libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-dev
                 libkrb5-dev libmcrypt-dev libpng-dev libssl-dev pkg-config libxml2-dev)
            when 20.04
              %w(libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-dev
                 libkrb5-dev libmcrypt-dev libpng-dev libssl-dev pkg-config libxml2-dev libsqlite3-dev libonig-dev)
            else # >= 22.04
              %w(libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-dev
                 libkrb5-dev libmcrypt-dev libpng-dev libssl-dev pkg-config libxml2-dev libsqlite3-dev libonig-dev)
            end
          else
            %w(libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg-dev libkrb5-dev
               libmcrypt-dev libpng-dev libssl-dev pkg-config libxml2-dev)
          end
        end
      end

      def php_src_recompile
        false
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

      def php_url
        'https://www.php.net/distributions'
      end
    end
  end
end
