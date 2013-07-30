node['php']['generic_modules'].each do |php_module, settings|
    if settings['package']
        package php_module do
            action :install
        end
    else
        if settings['dependencies'] && !settings['dependencies'].empty?
            settings['dependencies'].each do |dependency|
                package dependency do
                    action :install
                end
            end
        end

        if settings['prerequisite']
            include_recipe settings['prerequisite']
        end

        php_pear php_module do
            version settings['version'] || nil
            preferred_state settings['preferred_state'] || 'stable'
            directives settings['directives'] || {}
            zend_extensions settings['zend_extensions'] || []
            options settings['options'] || ''
        end
    end
end