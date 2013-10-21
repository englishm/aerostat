#!/usr/bin/env ruby

require "capistrano/ext/multistage"

set :chef_binary, "/usr/bin/chef-solo"
set :stages, Dir.entries(File.join(File.dirname(__FILE__),"deploy")).map{|item|item[/(.*?)(?=.rb)/]}.compact
set :default_stage, "vagrant"
set :use_sudo, true
set :ssh_d, File.join(Dir.home,".ssh","aerostat")
default_run_options[:pty] = true 
ssh_options[:forward_agent] = true
ssh_options[:config] = Dir.glob("#{ssh_d}/*")
set :chef_binary, "/usr/bin/chef-solo"

namespace :ssh do
  desc "Create SSH configuration file for {stage}. (Vagrant only)"
  task :generate_config do
    puts "Generating #{ssh_d}/#{stage}_ssh_config..."
    system("mkdir -p #{ssh_d}")
    system("vagrant ssh-config #{stage} > #{ssh_d}/#{stage}_ssh_config")
  end

  desc "Destroy SSH configuration file for {stage}. (Vagrant only)"
  task :destroy_config do
    puts "Destroying #{ssh_d}/#{stage}_ssh_config..."
    system("rm #{ssh_d}/#{stage}_ssh_config")
  end

  desc "Pretty-print SSH configuration file for {stage}."
  task :show_config do
    require 'PP'
    netssh_config = Net::SSH::Config.for("#{stage}", ssh_options[:config])
    pp netssh_config
  end

  desc "SSH into the system specified by {stage} using its SSH configuration file"
  task :default do
    system("ssh -F #{ssh_d}/#{stage}_ssh_config #{stage}")
  end
end

namespace :bootstrap do
  desc "Bootstrap Chef on {stage}"
  task :default do
    set :user, Net::SSH::Config.for("#{stage}", ssh_options[:config])[:user]
    set :id_file, Net::SSH::Config.for("#{stage}", ssh_options[:config])[:keys][0] if Net::SSH::Config.for("#{stage}", ssh_options[:config]).has_key?(:keys)
    set :hostname, Net::SSH::Config.for("#{stage}", ssh_options[:config])[:host_name]
    set :hostport, Net::SSH::Config.for("#{stage}", ssh_options[:config])[:port] || 22
    if exists?(:id_file)
      system("cd chef && knife bootstrap --bootstrap-version '11.4.2' -d chef-solo -x #{user} -i #{id_file} --sudo #{hostname} -p #{hostport}")
    else
      system("cd chef && knife bootstrap --bootstrap-version '11.4.2' -d chef-solo -x #{user} --sudo #{hostname} -p #{hostport}")
    end
  end
end

namespace :berks do
  desc "Vendorize cookbooks from the Berksfile into chef/cookbooks"
  task :default do
    system("berks install --path chef/cookbooks/")
  end
end

namespace :chef do
  desc "Create a TGZ from chef/, upload it, and run chef solo against it on {stage}"
  task :default do
    set :user, Net::SSH::Config.for("#{stage}", ssh_options[:config])[:user]
    if user[/root/]
      system("tar czf 'chef.tar.gz' -C chef/ .")
      upload("chef.tar.gz","/root",:via => :scp)
      run("rm -rf /root/chef")
      run("mkdir -p /root/chef")
      run("tar xzf 'chef.tar.gz' -C /root/chef")
      sudo("/bin/bash -c 'cd /root/chef && #{chef_binary} -c solo.rb -j #{stage}.json -N #{stage} --color'")
    else 
      system("tar czf 'chef.tar.gz' -C chef/ .")
      upload("chef.tar.gz","/home/#{user}",:via => :scp)
      run("rm -rf /home/#{user}/chef")
      run("mkdir -p /home/#{user}/chef")
      run("tar xzf 'chef.tar.gz' -C /home/#{user}/chef")
      sudo("/bin/bash -c 'cd /home/#{user}/chef && #{chef_binary} -c solo.rb -j #{stage}.json -N #{stage} --color'")
    end
  end
end

namespace :warning do
  desc "Show a warning if running against a Production {stage}"
  task :warning do
    logger.log(0,"*\n*\n*\n*\t\t\t!!  W A R N I N G  !!\n*\n*\t\tYou are about to run a POTENTIALLY DESTRUCTIVE action on #{stage.upcase}.\n*\n*\t\tIf you did not intend to do this, press CTRL + C now.\n*\n*\n*")
    sleep 5
  end
end

namespace :vg do
  desc "Boot Vagrant VM & generate SSH config."
  task :up do
    system("vagrant up #{stage}")
    find_and_execute_task("ssh:generate_config")
  end

  desc "Halt Vagrant VM & destroy SSH config."
  task :halt do
    system("vagrant halt #{stage}")
    find_and_execute_task("ssh:destroy_config")
  end

  desc "Destroy Vagrant VM & remove SSH config."
  task :destroy do
    system("vagrant destroy -f #{stage}")
    find_and_execute_task("ssh:destroy_config")
  end

  desc "Show status of Vagrant VM."
  task :status do
    system("vagrant status #{stage}")
  end

  namespace :all do
    desc "Show status of all Vagrant VM."
    task :status do
      system("vagrant status")
    end

    desc "Boot all Vagrant VM's."
    task :up do
      system("vagrant up")
    end

    desc "Destroy all Vagrant VM's."
    task :destroy do
      system("vagrant destroy")
    end

    desc "Halt all Vagrant VM's."
    task :halt do
      system("vagrant halt")
    end
  end
end

Dir.glob(File.join(File.dirname(__FILE__),"custom","*.rb")).each{|file|load "#{file}"}
