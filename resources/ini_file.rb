actions :create, :delete
default_action :create

attribute :path, :kind_of => String
attribute :settings, :kind_of => Hash, :required => true
attribute :enable_sections, :kind_of => [TrueClass, FalseClass], :default => false
