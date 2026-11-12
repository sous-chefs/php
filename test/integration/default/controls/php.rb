# frozen_string_literal: true

control 'php-default' do
  impact 1.0
  title 'The default PHP configuration matches the distribution and honours overrides'

  describe command('php -v') do
    its('exit_status') { should eq 0 }
  end

  describe command("php -c /tmp/php-ini-default/php.ini -r 'echo ini_get(\"request_order\");'") do
    its('stdout') { should cmp 'GP' }
  end

  describe command("php -c /tmp/php-ini-override/php.ini -r 'echo ini_get(\"request_order\");'") do
    its('stdout') { should cmp 'GPC' }
  end
end
