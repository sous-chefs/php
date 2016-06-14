require_relative '../spec_helper'

describe 'php::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  context 'on freebsd' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'freebsd', version: '10.0')
                          .converge(described_recipe)
    end

    it 'installs php' do
      expect(chef_run).to install_package('php56')
      expect(chef_run).not_to install_package('php5-cgi')
    end

    it 'installs pear' do
      expect(chef_run).to install_package('pear')
    end

    it 'creates /usr/local/etc/php.ini' do
      expect(chef_run).to create_template('/usr/local/etc/php.ini').with(
        source: 'php.ini.erb',
        cookbook: 'php',
        owner: 'root',
        mode: '0644',
        variables: {
          directives: {}
        }
      )
    end
  end
end
