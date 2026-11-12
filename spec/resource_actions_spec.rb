# frozen_string_literal: true

require 'spec_helper'

describe 'PHP custom resource actions' do
  platform 'ubuntu', '22.04'

  context 'when installing PHP' do
    step_into :php_install

    recipe do
      php_install 'php' do
        packages %w(php-cli php-fpm)
        conf_dir '/etc/php-test'
      end
    end

    it { is_expected.to install_package('Install PHP Packages').with(package_name: %w(php-cli php-fpm)) }
    it { is_expected.to add_php_ini('ini').with(conf_dir: '/etc/php-test') }
  end

  context 'when removing a PHP configuration' do
    step_into :php_ini

    recipe do
      php_ini 'default' do
        conf_dir '/etc/php-test'
        action :remove
      end
    end

    it { is_expected.to delete_file('/etc/php-test/php.ini') }
  end

  context 'when installing an FPM pool' do
    step_into :php_fpm_pool

    recipe do
      php_fpm_pool 'www' do
        pool_dir '/etc/php-test'
        fpm_package 'php-fpm'
        default_conf '/etc/php-test/default.conf'
        service 'php-fpm'
      end
    end

    it { is_expected.to install_package('php-fpm') }
    it { is_expected.to create_template('/etc/php-test/www.conf') }
    it { is_expected.to enable_service('php-fpm') }
  end

  context 'when removing an FPM pool' do
    step_into :php_fpm_pool

    recipe do
      php_fpm_pool 'www' do
        pool_dir '/etc/php-test'
        service 'php-fpm'
        action :uninstall
      end
    end

    it { is_expected.to delete_file('/etc/php-test/www.conf') }
  end

  context 'when discovering a missing PEAR channel' do
    step_into :php_pear_channel

    before do
      allow_any_instance_of(Chef::Provider).to receive(:shell_out!).and_raise(Mixlib::ShellOut::ShellCommandFailed)
    end

    recipe do
      php_pear_channel 'example.org' do
        action :discover
      end
    end

    it { is_expected.to run_execute('pear channel-discover example.org') }
  end

  context 'when removing an existing PEAR channel' do
    step_into :php_pear_channel

    before do
      allow_any_instance_of(Chef::Provider).to receive(:shell_out!).and_return(double('channel'))
    end

    recipe do
      php_pear_channel 'example.org' do
        action :remove
      end
    end

    it { is_expected.to run_execute('pear channel-delete example.org') }
  end

  context 'when adding a missing PEAR channel' do
    step_into :php_pear_channel

    before do
      allow_any_instance_of(Chef::Provider).to receive(:shell_out!).and_raise(Mixlib::ShellOut::ShellCommandFailed)
    end

    recipe do
      php_pear_channel 'example.org' do
        channel_xml 'https://example.org/channel.xml'
        action :add
      end
    end

    it { is_expected.to run_execute('pear channel-add https://example.org/channel.xml') }
  end

  context 'when an existing PEAR channel needs an update' do
    step_into :php_pear_channel

    before do
      allow_any_instance_of(Chef::Provider).to receive(:shell_out!).and_return(double('channel', stdout: ''))
      allow_any_instance_of(Chef::Provider).to receive(:shell_out).and_return(double('search', stdout: 'channel-update'))
    end

    recipe do
      php_pear_channel 'example.org' do
        action :update
      end
    end

    it 'updates the channel' do
      expect_any_instance_of(Chef::Provider).to receive(:shell_out!).with('pear channel-update example.org').and_return(double('channel', stdout: ''))
      chef_run
    end
  end

  context 'when declaring a PEAR installation' do
    step_into :php_pear

    before do
      allow_any_instance_of(Chef::Resource).to receive(:shell_out).and_return(double('pear', stdout: ''))
      allow_any_instance_of(Chef::Provider).to receive(:shell_out) do |_provider, command|
        double('pear', stdout: command.include?(' search') ? "Example 1.0.0 stable\n" : '')
      end
      allow_any_instance_of(Chef::Provider).to receive(:shell_out!).and_return(double('pear', stdout: ''))
    end

    recipe do
      php_pear 'Example' do
        action :install
      end
    end

    it { is_expected.to install_build_essential('') }

    it 'runs the PEAR installer for the requested package' do
      expect_any_instance_of(Chef::Provider).to receive(:shell_out!).with(/pear.* install .*Example/).and_return(double('pear', stdout: ''))
      chef_run
    end
  end

  %i(remove purge).each do |requested_action|
    context "when running #{requested_action} on an installed PEAR package" do
      step_into :php_pear

      before do
        installed = double('pear-list', stdout: "Installed packages:\nExample 1.0.0 stable\n")
        allow_any_instance_of(Chef::Resource).to receive(:shell_out).and_return(installed)
        allow_any_instance_of(Chef::Provider).to receive(:shell_out).and_return(installed)
        allow_any_instance_of(Chef::Provider).to receive(:shell_out!).and_return(double('pear', stdout: ''))
      end

      recipe do
        php_pear 'Example' do
          action requested_action
        end
      end

      it 'uninstalls the package' do
        expect_any_instance_of(Chef::Provider).to receive(:shell_out!).with(/pear uninstall.*Example/).and_return(double('pear', stdout: ''))
        chef_run
      end
    end
  end

  context 'when reinstalling a PEAR package' do
    step_into :php_pear

    before do
      allow_any_instance_of(Chef::Resource).to receive(:shell_out).and_return(double('pear-list', stdout: ''))
      allow_any_instance_of(Chef::Provider).to receive(:shell_out) do |_provider, command|
        double('pear', stdout: command.include?(' search') ? "Example 1.0.0 stable\n" : '')
      end
      allow_any_instance_of(Chef::Provider).to receive(:shell_out!).and_return(double('pear', stdout: ''))
    end

    recipe do
      php_pear 'Example' do
        version '1.0.0'
        action :reinstall
      end
    end

    it 'forces the requested version to be reinstalled' do
      expect_any_instance_of(Chef::Provider).to receive(:shell_out!).with(/pear.* install .* -f.*Example-1\.0\.0/).and_return(double('pear', stdout: ''))
      chef_run
    end
  end

  context 'when upgrading a PEAR package' do
    step_into :php_pear

    before do
      installed = double('pear-list', stdout: "Installed packages:\nExample 1.0.0 stable\n")
      allow_any_instance_of(Chef::Resource).to receive(:shell_out).and_return(installed)
      allow_any_instance_of(Chef::Provider).to receive(:shell_out).and_return(installed)
      allow_any_instance_of(Chef::Provider).to receive(:shell_out!).and_return(double('pear', stdout: ''))
      allow_any_instance_of(Chef::HTTP).to receive(:get).and_return('<a><r><s>stable</s><v>2.0.0</v></r></a>')
    end

    recipe do
      php_pear 'Example' do
        action :upgrade
      end
    end

    it 'upgrades to the current stable version' do
      expect_any_instance_of(Chef::Provider).to receive(:shell_out!).with(/pear.* upgrade .*Example-2\.0\.0/).and_return(double('pear', stdout: ''))
      chef_run
    end
  end
end
