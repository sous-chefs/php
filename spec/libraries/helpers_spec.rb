require 'spec_helper'
require_relative '../../libraries/helpers'

RSpec.describe Php::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include Php::Cookbook::Helpers
  end

  subject { DummyClass.new }

  describe '#php_version' do
    before do
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
      allow(subject).to receive(:[]).with('platform').and_return(platform)
      allow(subject).to receive(:[]).with('platform_version').and_return(platform_version)
    end

    context 'rhel' do
      let(:platform_family) { 'rhel' }
      let(:platform) { nil }
      let(:platform_version) { nil }
      it { expect(subject.php_version).to eq '7.2' }
    end

    context 'amazon' do
      let(:platform_family) { 'amazon' }
      let(:platform) { nil }
      let(:platform_version) { nil }
      it { expect(subject.php_version).to eq '8.2' }
    end

    context 'debian' do
      let(:platform_family) { 'debian' }

      context 'debian 10' do
        let(:platform) { 'debian' }
        let(:platform_version) { '10' }
        it { expect(subject.php_version).to eq '7.3' }
      end

      context 'debian 11' do
        let(:platform) { 'debian' }
        let(:platform_version) { '11' }
        it { expect(subject.php_version).to eq '7.4' }
      end

      context 'ubuntu 18.04' do
        let(:platform) { 'ubuntu' }
        let(:platform_version) { '18.04' }
        it { expect(subject.php_version).to eq '7.2' }
      end

      context 'ubuntu 20.04' do
        let(:platform) { 'ubuntu' }
        let(:platform_version) { '20.04' }
        it { expect(subject.php_version).to eq '7.4' }
      end

      context 'ubuntu 22.04' do
        let(:platform) { 'ubuntu' }
        let(:platform_version) { '22.04' }
        it { expect(subject.php_version).to eq '8.1' }
      end
    end
  end
end
