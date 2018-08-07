name 'php'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Installs and maintains php and php modules'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '6.1.1'

depends 'build-essential', '>= 5.0'
depends 'yum-epel'

%w(amazon centos debian fedora oracle redhat scientific suse opensuse opensuseleap ubuntu).each do |os|
  supports os
end

recipe 'php', 'Installs php'
recipe 'php::package', 'Installs php using packages.'
recipe 'php::source', 'Installs php from source.'

source_url 'https://github.com/chef-cookbooks/php'
issues_url 'https://github.com/chef-cookbooks/php/issues'
chef_version '>= 12.7' if respond_to?(:chef_version)
