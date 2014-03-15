require 'spec_helper'

describe package('php5') do
  it { should be_installed }
end

describe command('php --version') do
  it { should return_stdout /PHP 5\.[3-5]\.[0-9]+/ }
end

