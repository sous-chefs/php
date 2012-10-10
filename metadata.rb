maintainer       "Panagiotis Papadomitsos"
maintainer_email "pj@ezgr.net"
license          "Apache Public License 2.0"
description      "Installs/Configures PHP and various modules"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.1.1"

depends "build-essential"
depends "xml"
depends "yumrepo"

suggests "apache2"
suggests "nginx"

%w{ debian ubuntu centos redhat }.each do |os|
  supports os
end

attribute "php/conf_dir",
  :display_name => "The PHP configuration directory",
  :description => "The desired PHP configuration directory for the CLI binary",
  :calculated => true

attribute "php/apache_conf_dir",
  :display_name => "The PHP Apache configuration directory",
  :description => "The desired PHP configuration directory for the Apache module",
  :calculated => true

attribute "php/cgi_conf_dir",
  :display_name => "The PHP CGI configuration directory",
  :description => "The desired PHP configuration directory for the CGI binary",
  :calculated => true

attribute "php/ext_conf_dir",
  :display_name => "The PHP configuration include directory",
  :description => "The desired PHP configuration include directory",
  :calculated => true

attribute "php/session_dir",
  :display_name => "The PHP session directory",
  :description => "The desired PHP directory for session storage",
  :calculated => true

attribute "php/upload_dir",
  :display_name => "The PHP upload directory",
  :description => "The desired PHP directory for file uploads",
  :calculated => true

attribute "php/pear_dir",
  :display_name => "The PHP PEAR directory",
  :description => "The desired PHP PEAR library directory",
  :calculated => true

attribute "php/conf_dir",
  :display_name => "The PHP configuration directory",
  :description => "The desired PHP configuration directory for the CLI binary",
  :calculated => true

attribute "php/secure_functions",
  :display_name => "Enable PHP secure functions",
  :description => "Disable a set of PHP functions that are considered insecure",
  :default => "true"

attribute "php/ini_settings",
  :display_name => "Configurable PHP ini settings",
  :description => "A hash of INI variables that you can set for your PHP installation"

attribute "php/apc/shm_size",
  :display_name => "PHP APC shared memory size",
  :description => "Sets the PHP APC shared memory size",
  :default => "128M"

attribute "php/apc/local_size",
  :display_name => "PHP APC local cache size",
  :description => "Sets the PHP APC local cache size",
  :default => "128M"

attribute "php/url",
  :display_name => "PHP source download URL",
  :description => "Set the PHP download URL",
  :default => "http://us.php.net/distributions"

attribute "php/version",
  :display_name => "PHP source download version",
  :description => "Set the PHP download version",
  :default => "5.3.17"

attribute "php/checksum",
  :display_name => "PHP source file SHA-256 checksum",
  :description => "Set the PHP source file SHA-256 checksum",
  :default => "ad85e857d404b9e74f1e003deb574e94e3bb939f686e4e9a871d3a6b3f957509"

attribute "php/prefix_dir",
  :display_name => "PHP installation prefix",
  :description => "Set the PHP installation prefix",
  :default => "/usr/local"

attribute "php/configure_options",
  :display_name => "PHP source configuration options",
  :description => "Set an array of the PHP source configuration options"

attribute "php/fpm_conf_dir",
  :display_name => "PHP FPM configuration directory",
  :description => "Set the PHP FPM configuration directory",
  :calculated => true

attribute "php/fpm_pool_dir",
  :display_name => "PHP FPM instance pool directory",
  :description => "Set the PHP FPM instance pool directory",
  :calculated => true

attribute "php/fpm_log_dir",
  :display_name => "PHP FPM pool log directory",
  :description => "Set the PHP FPM pool log directory",
  :calculated => true

attribute "php/fpm_logfile",
  :display_name => "PHP FPM log file",
  :description => "Set the PHP FPM log file",
  :calculated => true

attribute "php/fpm_rotfile",
  :display_name => "PHP FPM log rotation file",
  :description => "Set the PHP FPM log rotation file",
  :calculated => true

