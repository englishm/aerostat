# Pairing

# Tmux
package "tmux"
cookbook_file ".tmux.conf" do
  path $pilot_home_path + "/.tmux.conf"
  source "tmux.conf"
  owner $pilot_username
  group $pilot_username
  mode 00644
end
git "#{$pilot_home_path}/git/github/tmux-colors-solarized/" do
  repository "https://github.com/seebi/tmux-colors-solarized"
  action :checkout
  user $pilot_username
  group $pilot_username
  ssh_wrapper "/usr/local/bin/aerostat-ssh.sh"
end
# wemux
git "/usr/local/share/wemux" do
  repository "git://github.com/zolrath/wemux.git"
  action :checkout
  ssh_wrapper "/usr/local/bin/aerostat-ssh.sh"
end
link "/usr/local/bin/wemux" do
  to "/usr/local/share/wemux/wemux"
end
template "/usr/local/etc/wemux.conf" do
  source "wemux.conf.erb"
  mode 00644
  variables(
    :host_list => $pilot_username,
  )
end
# copilot user
user $copilot_username do
  home $copilot_home_path
  shell "/bin/bash"
  supports :manage_home => true
end
directory "#{$copilot_home_path}/.ssh" do
  owner $copilot_username
  group $copilot_username
  mode 00700
end
file "#{$copilot_home_path}/.ssh/authorized_keys" do
  owner $copilot_username
  group $copilot_username
  mode 00600
end
