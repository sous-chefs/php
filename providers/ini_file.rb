def load_current_resource
  new_resource.path new_resource.name unless new_resource.path
end

action :create do
  t = template new_resource.path do
    source 'php.ini.erb'
    cookbook 'php'
    mode 0644
    variables(
      :settings => new_resource.settings,
      :disable_sections => !new_resource.enable_sections
    )
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)
end

action :delete do
  if(::File.exists?(new_resource.path))
    file new_resource.path do
      action :delete
    end
    new_resource.updated_by_last_action(true)
  end
end
