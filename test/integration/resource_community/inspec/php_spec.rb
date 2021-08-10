describe command('php -v') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match /PHP 8.0/ }
end

describe command('php-pear list-channels') do
  its('stdout') { should match /pear\.php\.net/ }
  its('stdout') { should match /pecl\.php\.net/ }
end

describe command('php --ri sync') do
  its('exit_status') { should eq 0 }
end

unless os[:family] == 'redhat'
  describe command('php -i') do
    its('stdout') { should match /50-sync/ }
  end

  # Check if we didn't accidentally pull in Apache as a dependency (#311)
  describe package('apache2') do
    it { should_not be_installed }
  end
end
