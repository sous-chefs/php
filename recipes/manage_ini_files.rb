node['php']['ini_files'].each do |ini_key, enabled|
  if(enabled)
    if(node['php']['ini_overrides'][ini_key])
      ini_settings = Chef::Mixin::DeepMerge.deep_merge(node['php']['ini_defaults'].to_hash, node['php']['ini_overrides'][ini_key].to_hash)
    else
      ini_settings = node['php']['ini_defaults'].to_hash
    end
    unless(node['php']['directives'].empty?)
      ini_settings['Extra'] = node['php']['directives'].to_hash
    end
    path = [node['php']['conf_dir']]
    path << ini_key unless ini_key == 'root'
    path << 'php.ini'
    php_ini_file path.join('/') do
      enable_sections true
      settings ini_settings
    end
  end
end
