# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'secrets.rb'

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.ssh.forward_agent = true
  config.vm.box = "wheezy64"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_debian-7.1.0_provisionerless.box"
  config.vm.define "aerostat" do |vagrant|
    vagrant.vm.hostname = "aerostat"
    vagrant.vm.network :private_network, type: :dhcp
  end

  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    override.vm.box = 'digital_ocean'
    override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"

    provider.client_id = $aerostat_secrets[:digitalocean_client_id]
    provider.api_key = $aerostat_secrets[:digitalocean_api_key]
    provider.image = "Debian 7.0 x64"
    provider.ssh_key_name = "aerostat"
  end
end
