# User setup

$pilot_username = node["aerostat"]["pilot"]["username"]
$pilot_github_username = node["aerostat"]["pilot"]["github_username"]
$copilot_username = node["aerostat"]["copilot"]["username"]
$copilot_github_usernames = node["aerostat"]["copilot"]["github_usernames"]
$pilot_home_path = "/home/#{$pilot_username}"
$copilot_home_path = "/home/#{$copilot_username}"

package "zsh"

user $pilot_username do
  home $pilot_home_path
  shell "/usr/bin/zsh"
  supports :manage_home => true
end

directory ".ssh" do
  path $pilot_home_path + "/.ssh"
  owner $pilot_username
  group $pilot_username
end

remote_file "authorized_keys" do
  path $pilot_home_path + "/.ssh/authorized_keys"
  source "https://github.com/#{$pilot_github_username}.keys"
  owner $pilot_username
  group $pilot_username
  mode 00644
end

template ".zshrc" do
  path $pilot_home_path + "/.zshrc"
  source "zshrc.erb"
  owner $pilot_username
  group $pilot_username
  mode 00644
end

node.default['authorization']['sudo']['passwordless'] = true
node.default['authorization']['sudo']['users'] = [$pilot_username]
include_recipe "sudo"
