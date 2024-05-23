# Set constants
set_conf_dir = nil
set_conf_dir = if platform_family?('rhel', 'amazon')
                 '/etc/opt/remi/php80'
               else
                 '/etc/php/8.2'
               end

apt_update 'update'

# Start of the old community_package recipe ---
if platform_family?('rhel')
  include_recipe 'yum-remi-chef::remi'
elsif platform?('ubuntu')
  # ondrej no longer supports Ubuntu <20.04
  if platform_version.to_i < 20
    Chef::Log.fatal 'Skipping run - Ubuntu <20.04 is not supported by the ondrej ppa'
    return
  end
  include_recipe 'ondrej_ppa_ubuntu'
elsif platform?('debian')
  # use sury repo for debian (https://deb.sury.org/)
  apt_repository 'sury-php' do
    uri 'https://packages.sury.org/php/'
    key 'https://packages.sury.org/php/apt.gpg'
    components %w(main)
  end
# Amazon Linux isn't supported by Remi
elsif platform_family?('amazon')
  Chef::Log.fatal 'Skipping run - Amazon Linux is not supported by Remi'
  return
end

php_install 'Install PHP from community repo' do
  conf_dir set_conf_dir
  if platform_family?('rhel', 'amazon')
    lib_dir = node['kernel']['machine'] =~ /x86_64/ ? 'lib64' : 'lib'

    packages %w(php80 php80-php-devel php80-php-cli php80-php-xml php80-php-pear)
    ext_dir "/opt/remi/php80/root/#{lib_dir}/php/modules"
  else
    packages %w(php8.2 php8.2-cgi php8.2-cli php8.2-dev php8.2-xml php-pear)
  end
end

# End of old community_package recipe ---

# README: The Remi repo intentionally avoids installing the binaries to
#         the default paths. It comes with a /opt/remi/php80/enable profile
#         which can be copied or linked into /etc/profiles.d to auto-load for
#         operators in a real cookbook.
if platform_family?('rhel', 'amazon')
  link '/usr/bin/php' do
    to '/usr/bin/php80'
  end

  link '/usr/bin/pear' do
    to '/usr/bin/php80-pear'
  end

  link '/usr/bin/pecl' do
    to '/opt/remi/php80/root/bin/pecl'
  end

  link '/etc/profile.d/php80-enable.sh' do
    to '/opt/remi/php80/enable'
  end
end

# Create a test pool
php_fpm_pool 'test-pool' do
  fpm_ini_control true
  if platform_family?('rhel', 'amazon')
    service 'php80-php-fpm'
    fpm_conf_dir '/etc/opt/remi/php80/php-fpm.d'
    listen '/var/run/php-test-fpm.sock'
    pool_dir '/etc/opt/remi/php80/php-fpm.d'
    fpm_package 'php80-php-fpm'
    default_conf '/etc/opt/remi/php80/php-fpm.d/www.conf'
  else
    service 'php8.2-fpm'
    fpm_conf_dir '/etc/php/8.2/fpm'
    listen '/var/run/php/php8.2-fpm.sock'
    pool_dir '/etc/php/8.2/fpm/pool.d'
    fpm_package 'php8.2-fpm'
    default_conf '/etc/php/8.2/fpm/pool.d/www.conf'
  end
end

# Add PEAR channel
php_pear_channel 'pear.php.net' do
  action :update
end

# Install https://pear.php.net/package/HTTP2
php_pear 'HTTP2'

# Add PECL channel
php_pear_channel 'pecl.php.net' do
  action :update
end

# Install https://pecl.php.net/package/sync
php_pear 'sync-binary' do
  conf_dir set_conf_dir
  if platform_family?('rhel', 'amazon')
    ext_conf_dir '/etc/opt/remi/php80/php.d'
  else
    ext_conf_dir '/etc/php/8.2/mods-available'
  end
  package_name 'sync'
  binary 'pecl'
  priority '50'
end
