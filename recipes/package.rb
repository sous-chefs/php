if platform_family?('rhel', 'debian', 'amazon', 'suse')
  package node['php']['packages'] do
    options node['php']['package_options']
  end
else
  node['php']['packages'].each do |pkg|
    package pkg do
      options node['php']['package_options']
    end
  end
end

include_recipe 'php::ini'
