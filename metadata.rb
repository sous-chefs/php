name 'php'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Installs and maintains php and php modules'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '4.5.0'

depends 'build-essential'
depends 'mysql', '>= 6.0.0'
depends 'yum-epel'

%w(amazon centos debian fedora oracle redhat scientific suse opensuse opensuseleap ubuntu).each do |os|
  supports os
end

recipe 'php', 'Installs php'
recipe 'php::package', 'Installs php using packages.'
recipe 'php::source', 'Installs php from source.'
recipe 'php::module_apc', 'Install the php5-apc package'
recipe 'php::module_curl', 'Install the php5-curl package'
recipe 'php::module_fileinfo', 'Install the php5-fileinfo package'
recipe 'php::module_fpdf', 'Install the php-fpdf package'
recipe 'php::module_gd', 'Install the php5-gd package'
recipe 'php::module_imap', 'Install the php5-imap package'
recipe 'php::module_ldap', 'Install the php5-ldap package'
recipe 'php::module_memcache', 'Install the php5-memcache package'
recipe 'php::module_mysql', 'Install the php5-mysql package'
recipe 'php::module_pgsql', 'Install the php5-pgsql packag'
recipe 'php::module_sqlite3', 'Install the php5-sqlite3 package'

source_url 'https://github.com/chef-cookbooks/php'
issues_url 'https://github.com/chef-cookbooks/php/issues'
chef_version '>= 12.7' if respond_to?(:chef_version)
