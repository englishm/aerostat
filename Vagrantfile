# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.ssh.forward_agent = true
  config.vm.box = "wheezy64"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_debian-7.1.0_provisionerless.box"

  Dir.entries(File.join(File.dirname(__FILE__),"config","deploy")).map{|item|item[/(v.*?)(?=.rb)/]}.compact.each{|stage|
    next if stage[/vagrant/]
    config.vm.define "#{stage}" do |vagrant|
      vagrant.vm.hostname = "#{stage}"
      vagrant.vm.network :private_network, type: :dhcp
    end
  }
end
