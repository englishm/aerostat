# Project repos
directory "#{$pilot_home_path}/git" do
  action :create
  owner $pilot_username
  group $pilot_username
  mode 00700
end

git "#{$pilot_home_path}/git/aerostat" do
  repository node["aerostat"]["repo_url"]
  action :checkout
  user $pilot_username
  group $pilot_username
  ssh_wrapper "/usr/local/bin/aerostat-ssh.sh"
end

directory "#{$pilot_home_path}/git/github" do
  action :create
  owner $pilot_username
  group $pilot_username
  mode 00700
end

link "#{$pilot_home_path}/gh" do
  to "#{$pilot_home_path}/git/github"
  user $pilot_username
  group $pilot_username
end
