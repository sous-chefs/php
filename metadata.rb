name 'php'
maintainer 'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license 'Apache-2.0'
description 'Installs and maintains php and php modules'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/chef-cookbooks/php'
issues_url 'https://github.com/chef-cookbooks/php/issues'
chef_version '>= 13.0'
version '7.0.0'

depends 'build-essential', '>= 5.0'
depends 'yum-epel'

%w(amazon centos debian fedora oracle redhat scientific suse opensuse opensuseleap ubuntu).each do |os|
  supports os
end
