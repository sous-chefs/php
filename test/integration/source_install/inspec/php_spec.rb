describe command('php -v') do
  its('exit_status') { should eq 0 }
end

describe command('pear list-channels') do
  its('stdout') { should match(/pear\.php\.net/) }
  its('stdout') { should match(/pecl\.php\.net/) }
end
