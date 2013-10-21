# Git/SSH
directory "/etc/aerostat" do
  owner $pilot_username
  group $pilot_username
  mode 00744
end

cookbook_file "/etc/aerostat/id_rsa" do
  source "secrets/id_rsa" # .gitignored!
  owner $pilot_username
  group $pilot_username
  mode 00600
end

cookbook_file "/etc/aerostat/id_rsa.pub" do
  source "secrets/id_rsa.pub" # .gitignored!
  owner $pilot_username
  group $pilot_username
  mode 00644
end

cookbook_file "/etc/ssh/ssh_known_hosts" do
  source "secrets/ssh_known_hosts" # .gitignored!
  owner $pilot_username
  group $pilot_username
  mode 00744
end

file "/usr/local/bin/aerostat-ssh.sh" do
  owner $pilot_username
  group $pilot_username
  mode 00744
  content <<EOS
#!/bin/bash
/usr/bin/env ssh -i "/etc/aerostat/id_rsa" $1 $2
EOS
end

file "#{$pilot_home_path}/.ssh/config" do
  owner $pilot_username
  group $pilot_username
  mode 00600
  content <<EOS
Host *
  IdentityFile /etc/aerostat/id_rsa
EOS
end

template ".gitconfig" do
  path $pilot_home_path + "/.gitconfig"
  source "gitconfig.erb"
  owner $pilot_username
  group $pilot_username
  mode 00644
end
