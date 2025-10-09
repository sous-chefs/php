#
# Author:: Seth Chisamore <schisamo@chef.io>
# Cookbook:: php
# Resource:: pear
#
# Copyright:: 2011-2021, Chef Software, Inc <legal@chef.io>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

unified_mode true

property :package_name, String, name_property: true
property :version, [String, nil]
property :channel, String
property :options, String
property :directives, Hash, default: {}
property :zend_extensions, Array, default: []
property :preferred_state, String, default: 'stable'
property :binary, String, default: 'pear'
property :priority, [String, nil]
property :enable_mod, String, default: lazy { php_enable_mod }
property :disable_mod, String, default: lazy { php_disable_mod }
property :pecl, String, default: lazy { php_pecl }
property :conf_dir, String, default: lazy { php_conf_dir }
property :ext_conf_dir, String, default: lazy { php_ext_conf_dir }

def current_installed_version(new_resource)
  version_check_cmd = "#{new_resource.binary} -d"
  version_check_cmd << " preferred_state=#{new_resource.preferred_state}"
  version_check_cmd << " list#{expand_channel(new_resource.channel)}"
  p = shell_out(version_check_cmd)
  response = nil
  response = grep_for_version(p.stdout, new_resource.package_name) if p.stdout =~ /\.?Installed packages/i
  response
end

def expand_channel(channel)
  channel ? " -c #{channel}" : ''
end

def grep_for_version(stdout, package)
  version = nil
  stdout.split("\n").grep(/^#{package}\s/i).each do |m|
    # XML_RPC          1.5.4    stable
    # mongo   1.1.4/(1.1.4 stable) 1.1.4 MongoDB database driver
    # Horde_Url -n/a-/(1.0.0beta1 beta)       Horde Url class
    # Horde_Url 1.0.0beta1 (beta) 1.0.0beta1 Horde Url class
    version = m.split(/\s+/)[1].strip
    version = if version.split(%r{///}).first =~ /.\./
                # 1.1.4/(1.1.4 stable)
                version.split(%r{///}).first
              else
                # -n/a-/(1.0.0beta1 beta)
                version.split(%r{/(.*)/\((.*)/}).last.split(/\s/).first
              end
  end
  version
end

load_current_value do |new_resource|
  unless current_installed_version(new_resource).nil?
    version(current_installed_version(new_resource))
    Chef::Log.debug("Current version is #{version}") if version
  end
end

action :install do
  build_essential

  # If we specified a version, and it's not the current version, move to the specified version
  unless new_resource.version.nil? || new_resource.version == current_resource.version
    install_version = new_resource.version
  end
  # Check if the version we want is already installed
  versions_match = candidate_version == current_installed_version(new_resource)

  # If it's not installed at all or an upgrade, install it
  if install_version || new_resource.version.nil? && !versions_match
    converge_by("install package #{new_resource.package_name} #{install_version}") do
      info_output = "Installing #{new_resource.package_name}"
      info_output << " version #{install_version}" if install_version && !install_version.empty?
      Chef::Log.info(info_output)
      install_package(new_resource.package_name, install_version)
    end
  end
end

# reinstall is just an install that always fires
action :reinstall do
  build_essential

  install_version = new_resource.version unless new_resource.version.nil?
  converge_by("reinstall package #{new_resource.package_name} #{install_version}") do
    info_output = "Installing #{new_resource.package_name}"
    info_output << " version #{install_version}" if install_version && !install_version.empty?
    Chef::Log.info(info_output)
    install_package(new_resource.package_name, install_version, force: true)
  end
end

action :upgrade do
  if current_resource.version != candidate_version
    orig_version = @current_resource.version || 'uninstalled'
    description = "upgrade package #{new_resource.package_name} version from #{orig_version} to #{candidate_version}"
    converge_by(description) do
      upgrade_package(new_resource.package_name, candidate_version)
    end
  end
end

action :remove do
  if removing_package?
    converge_by("remove package #{new_resource.package_name}") do
      remove_package(@current_resource.package_name, new_resource.version)
    end
  end
end

action :purge do
  if removing_package?
    converge_by("purge package #{new_resource.package_name}") do
      remove_package(@current_resource.package_name, new_resource.version)
    end
  end
end

action_class do
  def expand_options(options)
    options ? " #{options}" : ''
  end

  def candidate_version
    base_url = "https://#{new_resource.channel || new_resource.binary + '.php.net'}/"
    package_version_url = "/rest/r/#{new_resource.package_name.downcase}/allreleases.xml"
    # url = "https://#{new_resource.channel || new_resource.binary + '.php.net'}/rest/r/#{new_resource.package_name.downcase}/allreleases.xml"
    versions_response = Chef::HTTP.new(base_url).get(package_version_url)

    require 'nokogiri'
    doc = Nokogiri::XML(versions_response)
    doc.remove_namespaces!
    rows = doc.xpath('//r')
    rows.each do |r|
      next unless r.at_xpath('.//s').content == new_resource.preferred_state
      break r.at_xpath('.//v').content
    end
  end

  def install_package(name, version, **opts)
    command = "printf \"\r\" | #{new_resource.binary} -d"
    command << " preferred_state=#{new_resource.preferred_state}"
    command << " install -a#{expand_options(new_resource.options)}"
    command << ' -f' if opts[:force] # allows us to force a reinstall
    command << " #{prefix_channel(new_resource.channel)}#{name}"
    command << "-#{version}" if version && !version.empty?
    pear_shell_out(command)
    if pecl?
      manage_pecl_ini(name, :create, new_resource.directives, new_resource.zend_extensions,
                      new_resource.priority)
    end
    enable_package(name)
  end

  def upgrade_package(name, version)
    command = "printf \"\r\" | #{new_resource.binary} -d"
    command << " preferred_state=#{new_resource.preferred_state}"
    command << " upgrade -a#{expand_options(new_resource.options)}"
    command << " #{prefix_channel(new_resource.channel)}#{name}"
    command << "-#{version}" if version && !version.empty?
    pear_shell_out(command)
    if pecl?
      manage_pecl_ini(name, :create, new_resource.directives, new_resource.zend_extensions,
                      new_resource.priority)
    end
    enable_package(name)
  end

  def remove_package(name, version)
    command = "#{new_resource.binary} uninstall"
    command << " #{expand_options(new_resource.options)}"
    command << " #{prefix_channel(new_resource.channel)}#{name}"
    command << "-#{version}" if version && !version.empty?
    pear_shell_out(command)
    disable_package(name)
    manage_pecl_ini(name, :delete, nil, nil, nil) if pecl?
  end

  def enable_package(name)
    execute "#{new_resource.enable_mod} #{name}" do
      only_if { platform?('ubuntu') && ::File.exist?(new_resource.enable_mod) }
    end
  end

  def disable_package(name)
    execute "#{new_resource.disable_mod} #{name}" do
      only_if { platform?('ubuntu') && ::File.exist?(new_resource.disable_mod) }
    end
  end

  def pear_shell_out(command)
    p = shell_out!(command)
    # pear/pecl commands return a 0 on failures...we'll grep for it
    p.invalid! if p.stdout.split('\n').last =~ /^ERROR:.+/i
    p
  end

  def prefix_channel(channel)
    channel ? "#{channel}/" : ''
  end

  def removing_package?
    if new_resource.version.nil?
      true # remove any version of a package
    else
      new_resource.version == @current_resource.version # we don't have the version we want to remove
    end
  end

  def extension_dir
    @extension_dir ||= begin
      # Consider using "pecl config-get ext_dir". It is more cross-platform.
      # p = shell_out("php-config --extension-dir")
      p = shell_out("#{new_resource.pecl} config-get ext_dir")
      p.stdout.strip
    end
  end

  def get_extension_files(name)
    # use appropriate binary when listing pecl packages
    list_binary = if new_resource.channel == 'pecl.php.net'
                    new_resource.pecl
                  else
                    new_resource.binary
                  end

    p = shell_out("#{list_binary} list-files #{name}")
    p.stdout.each_line.grep(/^(src|ext)\s+.*\.so$/i).map do |line|
      line.split[1]
    end
  end

  def pecl?
    @pecl ||=
      begin
        # search as a pear first since most 3rd party channels will report pears as pecls!
        search_args = ''
        search_args << " -d preferred_state=#{new_resource.preferred_state}"
        search_args << " search#{expand_channel(new_resource.channel)} #{new_resource.package_name}"

        if grep_for_version(shell_out(new_resource.binary + search_args).stdout, new_resource.package_name)
          if (new_resource.binary.include? 'pecl') || (new_resource.channel == 'pecl.php.net')
            true
          else
            false
          end
        elsif grep_for_version(shell_out(new_resource.pecl + search_args).stdout, new_resource.package_name)
          true
        else
          raise "Package #{new_resource.package_name} not found in either PEAR or PECL."
        end
      end
  end

  def manage_pecl_ini(name, action, directives, zend_extensions, priority)
    ext_prefix = extension_dir
    ext_prefix << ::File::SEPARATOR if ext_prefix.last.chr != ::File::SEPARATOR

    files = get_extension_files(name)

    extensions = Hash[
                 files.map do |filepath|
                   rel_file = filepath.clone
                   rel_file.slice! ext_prefix if rel_file.start_with? ext_prefix
                   zend = zend_extensions.include?(rel_file)
                   [(zend ? filepath : rel_file), zend]
                 end
    ]

    directory new_resource.ext_conf_dir do
      owner 'root'
      group 'root'
      mode '0755'
      recursive true
    end

    template "#{new_resource.ext_conf_dir}/#{name}.ini" do
      source 'extension.ini.erb'
      cookbook 'php'
      owner 'root'
      group 'root'
      mode '0644'
      variables(
        name: name,
        extensions: extensions,
        directives: directives,
        priority: priority
      )
      action action
    end

    execute "#{new_resource.enable_mod} #{name}" do
      creates "#{new_resource.conf_dir}/conf.d/#{name}"
      only_if { platform_family? 'debian' }
    end
  end
end
