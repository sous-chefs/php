describe 'PHP' do
  it 'has PHP 8.0' do
    expect(command('php -v').stdout).to match(/PHP 8.0/)
  end

  it 'has the pear.php.net channel' do
    expect(command('php-pear list-channels').stdout).to include('pear.php.net')
  end

  it 'has the pecl.php.net channel' do
    expect(command('php-pear list-channels').stdout).to include('pecl.php.net')
  end

  it 'has the PECL sync module' do
    expect(command('php --ri sync').exit_status).to eq(0)
  end

  unless os[:family] == 'redhat'
    it 'has the correct priority set' do
      expect(command('php -i').stdout).to include('50-sync')
    end
  end
end

# Check if we didn't accidentally pull in Apache as a dependency (#311)
unless os[:family] == 'redhat'
  describe package('apache2') do
    it { should_not be_installed }
  end
end
