describe 'PHP' do
  it 'has php' do
    expect(command('php -v').exit_status).to eq(0)
  end

  it 'has the pear.php.net channel' do
    expect(command('pear list-channels').stdout).to include('pear.php.net')
  end

  it 'has the pecl.php.net channel' do
    expect(command('pear list-channels').stdout).to include('pecl.php.net')
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
