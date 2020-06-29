require 'spec_helper'

shared_examples_for 'php' do
  it 'installs php and pear' do
    expect(chef_run).to install_package packages
  end

  it 'creates php.ini' do
    expect(chef_run).to create_template php_ini_path
  end
end

describe 'php::default' do
  context 'on amazon linux 2' do
    platform 'amazon', '2'

    let(:packages) { %w(php php-devel php-pear) }
    let(:php_ini_path) { '/etc/php.ini' }

    it_should_behave_like 'php'
  end

  context 'on centos 7' do
    platform 'centos', '7'

    let(:packages) { %w(php php-devel php-cli php-pear) }
    let(:php_ini_path) { '/etc/php.ini' }

    it_should_behave_like 'php'
  end

  context 'on debian 9' do
    platform 'debian', '9'

    let(:packages) { ['php7.0-cgi', 'php7.0', 'php7.0-dev', 'php7.0-cli', 'php-pear'] }
    let(:php_ini_path) { '/etc/php/7.0/cli/php.ini' }

    it_should_behave_like 'php'
  end

  context 'on debian 10' do
    platform 'debian', '10'

    let(:packages) { %w(php-cgi php php-dev php-cli php-pear) }
    let(:php_ini_path) { '/etc/php/7.3/cli/php.ini' }

    it_should_behave_like 'php'
  end

  context 'on ubuntu 16.04' do
    platform 'ubuntu', '16.04'

    let(:packages) { ['php7.0-cgi', 'php7.0', 'php7.0-dev', 'php7.0-cli', 'php-pear'] }
    let(:php_ini_path) { '/etc/php/7.0/cli/php.ini' }

    it_should_behave_like 'php'
  end

  context 'on ubuntu 18.04' do
    platform 'ubuntu', '18.04'

    let(:packages) { ['php7.2-cgi', 'php7.2', 'php7.2-dev', 'php7.2-cli', 'php-pear'] }
    let(:php_ini_path) { '/etc/php/7.2/cli/php.ini' }

    it_should_behave_like 'php'
  end

  context 'on ubuntu 20.04' do
    platform 'ubuntu', '20.04'

    let(:packages) { %w(php-cgi php php-dev php-cli php-pear) }
    let(:php_ini_path) { '/etc/php/7.4/cli/php.ini' }

    it_should_behave_like 'php'
  end
end
