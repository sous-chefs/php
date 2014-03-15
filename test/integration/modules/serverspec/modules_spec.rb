require 'spec_helper'
require 'specinfra/helper'

# Hack to detect OS version at test-kitchen verify time
SpecInfra::Helper::DetectOS.commands
os = SpecInfra::Helper::Properties.property[:os_by_host]['localhost']

# Check the right package name depending on OS
case os[:family]
when 'RedHat'
  case os[:release].to_f
  when 5.10
    php_pkgname = 'php53'
  when 6.5
    php_pkgname = 'php'
  when 19 # Fedora
    php_pkgname = 'php'
  end
when 'Ubuntu'
  php_pkgname = 'php5'
end

  {
   'php5-mcrypt' => 'mcrypt'
  }.each_pair do |package_name, phpinfo_module_name|

  describe package(package_name) do
    it { should be_installed }
  end

  describe command('php -r "phpinfo();"') do
    it { should return_stdout /#{phpinfo_module_name}\s+support\s+=>\s+enabled/i }
  end
end
