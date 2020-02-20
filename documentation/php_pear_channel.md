# `php_pear_channel`

[PEAR Channels](http://pear.php.net/manual/en/guide.users.commandline.channels.php) are alternative sources for PEAR packages. This resource provides and easy way to manage these channels.

## Actions

- `:discover`: Initialize a channel from its server.
- `:add`: Add a channel to the channel list, usually only used to add private channels. Public channels are usually added using the `:discover` action
- `:update`: Update an existing channel
- `:remove`: Remove a channel from the List

## Properties

| Name           | Type     | Default | Descrption                                          |
| -------------- | -------- | ------- | --------------------------------------------------- |
| `channel_name` | `String` |         | Name attribute. The name of the channel to discover |
| `channel_xml`  | `String` |         | The channel.xml file of the channel you are adding  |
| `binary`       | `String` | `pear`  | Pear binary, default: pear                          |

## Examples

```ruby
# discover the horde channel
php_pear_channel "pear.horde.org" do
  action :discover
end

# download xml then add the symfony channel
remote_file "#{Chef::Config[:file_cache_path]}/symfony-channel.xml" do
  source 'http://pear.symfony-project.com/channel.xml'
  mode '0644'
end
php_pear_channel 'symfony' do
  channel_xml "#{Chef::Config[:file_cache_path]}/symfony-channel.xml"
  action :add
end

# update the main pear channel
php_pear_channel 'pear.php.net' do
  action :update
end

# update the main pecl channel
php_pear_channel 'pecl.php.net' do
  action :update
end
```
