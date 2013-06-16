name              'php'
maintainer        'Panagiotis Papadomitsos'
maintainer_email  'pj@ezgr.net'
license           'Apache Public License 2.0'
description       'Installs/Configures PHP and various modules'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md')).chomp
version           IO.read(File.join(File.dirname(__FILE__), 'VERSION')).chomp rescue '0.1.0'

depends           'build-essential'
depends           'xml'
depends           'yumrepo'

suggests          'apache2'
suggests          'nginx'

supports          'ubuntu', '>= 12.04'
supports          'debian', '>= 6.0'
supports          'centos', '>= 6.0'
supports          'redhat', '>= 9.0'
