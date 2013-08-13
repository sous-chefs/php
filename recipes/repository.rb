#####
#Channel Grabber Recipe to install php packages from external repo
#####

if node['php']['repository']['uri'].to_s != '' 
  apt_repository "php5" do
    uri node['php']['repository']['uri']
    deb_src node['php']['repository']['deb_src']
    distribution node['php']['repository']['distribution']
    components node['php']['repository']['components']
    keyserver node['php']['repository']['keyserver']
    key node['php']['repository']['key']
    action :add
  end
end