require_relative '../spec_helper'

describe 'php::default' do

  context 'on freebsd' do
    let(:chef_run) {
      ChefSpec::SoloRunner.new(platform: 'freebsd', version: '10.0')
        .converge(described_recipe)
    }

    it 'installs php' do
      expect(chef_run).to install_package('php5')
      expect(chef_run).not_to install_package('php5-cgi')
    end
  end

end
