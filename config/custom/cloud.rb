namespace :digitalocean do
  desc "Create a new 'aerostat' Droplet"
  task "create" do
    require 'fog'
    compute_service = Fog::Compute.new({
      :provider => 'digitalocean',
      :digitalocean_api_key => $aerostat_secrets[:digitalocean_api_key],
      :digitalocean_client_id => $aerostat_secrets[:digitalocean_client_id],
    })
    image = compute_service.images.find{|img| img.name == 'Debian 7.0 x64' }
    flavor = compute_service.flavors.find { |f| f.name == '512MB' }
    data = compute_service.create_server("aerostat",  flavor.id,  image.id, compute_service.regions.first.id)
    puts data.body.to_yaml
    puts "Waiting 60 seconds for Droplet to be created..."
    sleep 60
    droplet = compute_service.servers.find{|s| s.id == data.body["droplet"]["id"]}
    puts "IP Address: #{droplet.public_ip_address}"
    set :aerostat_ip, droplet.public_ip_address
  end

  desc "Destroy the 'aerostat' Droplet"
  task "destroy" do
    require 'fog'
    compute_service = Fog::Compute.new({
      :provider => 'digitalocean',
      :digitalocean_api_key => $aerostat_secrets[:digitalocean_api_key],
      :digitalocean_client_id => $aerostat_secrets[:digitalocean_client_id],
    })
    # droplet = compute_service.servers.find{|s| s.name == "aerostat" }
    # droplet.destroy
  end
end

namespace :dnsimple do
  desc "Create DNS entry for new host."
  task "create" do
    require 'fog'
    dns_service = Fog::DNS.new({
      :provider => 'dnsimple',
      :dnsimple_email => $aerostat_secrets[:dnsimple_email],
      :dnsimple_password => $aerostat_secrets[:dnsimple_password],
    })
    dns_domain = "mikeenglish.net"
    dns_record = "aerostat"
    dns_type = "A"
    dns_content = aerostat_ip
    dns_ttl = 300
    dns_service.create_record(
      dns_domain,
      dns_record,
      dns_type,
      dns_content,
      {:ttl => dns_ttl}
    )
  end
end







