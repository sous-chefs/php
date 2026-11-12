# frozen_string_literal: true

require 'spec_helper'

describe 'php_ini' do
  step_into :php_ini

  context 'on Red Hat 9' do
    platform 'redhat', '9'

    recipe do
      php_ini 'default' do
        conf_dir '/etc'
        directives 'request_order' => 'GPC'
      end
    end

    it { is_expected.to render_file('/etc/php.ini').with_content(/^request_order = "GP"$.*^request_order=GPC$/m) }
  end

  context 'on Red Hat 8' do
    platform 'redhat', '8'

    recipe do
      php_ini 'default' do
        conf_dir '/etc'
      end
    end

    it { is_expected.to render_file('/etc/php.ini').with_content(/^request_order = "GP"$/) }
  end

  context 'on Red Hat 7' do
    platform 'redhat', '7'

    recipe do
      php_ini 'default' do
        conf_dir '/etc'
      end
    end

    it { is_expected.not_to render_file('/etc/php.ini').with_content(/^request_order\s*=/) }
  end

  context 'on CentOS 7' do
    platform 'centos', '7'

    recipe do
      php_ini 'default' do
        conf_dir '/etc'
      end
    end

    it { is_expected.to render_file('/etc/php.ini').with_content(/^request_order = "GP"$/) }
  end

  context 'on CentOS 8' do
    platform 'centos', '8'

    recipe do
      php_ini 'default' do
        conf_dir '/etc'
      end
    end

    it { is_expected.to render_file('/etc/php.ini').with_content(/^request_order = "GP"$/) }
  end

  context 'on CentOS 9' do
    platform 'centos-stream', '9'

    recipe do
      php_ini 'default' do
        conf_dir '/etc'
      end
    end

    it { is_expected.to render_file('/etc/php.ini').with_content(/^request_order = "GP"$/) }
  end
end
