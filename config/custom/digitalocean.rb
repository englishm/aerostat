namespace :digitalocean do
  desc "Create a new Droplet"
  task "create" do
    require 'fog'
    service = Fog::Compute.new({
      :provider => 'digitalocean',
      :digitalocean_api_key => $aerostat_secrets[:digitalocean_api_key],
      :digitalocean_client_id => $aerostat_secrets[:digitalocean_client_id],
    })
    image = service.images.find{|img| img.name == 'Debian 7.0 x64' }
    flavor = service.flavors.find { |f| f.name == '512MB' }
    data = service.create_server("fogtest",  flavor.id,  image.id, service.regions.first.id)
    puts data.body.to_yaml
    puts "Waiting 60 seconds for Droplet to be created..."
    sleep 60
    droplet = service.servers.find{|s| s.id == data.body["droplet"]["id"]}
    puts "IP Address: #{droplet.public_ip_address}"
  end
end


