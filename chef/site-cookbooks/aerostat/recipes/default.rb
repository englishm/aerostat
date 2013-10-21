node.default["aerostat"]["pilot"]["username"] = "english"
node.default["aerostat"]["pilot"]["github_username"] = "englishm"
node.default["aerostat"]["copilot"]["username"] = "copilot"

# User

pilot_username = node["aerostat"]["pilot"]["username"]
pilot_github_username = node["aerostat"]["pilot"]["github_username"]
copilot_username = node["aerostat"]["copilot"]["username"]
copilot_github_usernames = node["aerostat"]["copilot"]["github_usernames"]
pilot_home_path = "/home/#{pilot_username}"
copilot_home_path = "/home/#{copilot_username}"

package "zsh"

user pilot_username do
  home pilot_home_path
  shell "/usr/bin/zsh"
  supports :manage_home => true
end

directory ".ssh" do
  path pilot_home_path + "/.ssh"
  owner pilot_username
  group pilot_username
end

remote_file "authorized_keys" do
  path pilot_home_path + "/.ssh/authorized_keys"
  source "https://github.com/#{pilot_github_username}.keys"
  owner pilot_username
  group pilot_username
  mode 00644
end

cookbook_file ".zshrc" do
  path pilot_home_path + "/.zshrc"
  source "zshrc"
  owner pilot_username
  group pilot_username
  mode 00644
end

node.default['authorization']['sudo']['passwordless'] = true
node.default['authorization']['sudo']['users'] = [pilot_username]
include_recipe "sudo"

# Ruby

node.default[:rbenv][:group_users] = [pilot_username]
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
include_recipe "rbenv::rbenv_vars"
rbenv_ruby "2.0.0-p247" do
  global true
end
rbenv_ruby "1.9.3-p392"
rbenv_ruby "1.8.7-p371"
rbenv_gem "bundler" do
  ruby_version "2.0.0-p247"
end
rbenv_gem "bundler" do
  ruby_version "1.9.3-p392"
end
rbenv_gem "bundler" do
  ruby_version "1.8.7-p371"
end
rbenv_gem "pry" do
  ruby_version "2.0.0-p247"
end
rbenv_gem "github-auth" do
  ruby_version "2.0.0-p247"
end
# rbenv-alias
git "/opt/rbenv/plugins/rbenv-aliases" do
  repository "https://github.com/tpope/rbenv-aliases"
  action :checkout
  user "rbenv"
  group "rbenv"
  ssh_wrapper "/usr/local/bin/aerostat-ssh.sh"
end
rbenv_execute "rbenv alias --auto" do
  user "rbenv"
  not_if "ls /opt/rbenv/versions/2.0.0"
end

# Erlang
package "erlang"

# Clojure
package "openjdk-7-jre"
remote_file "/usr/local/bin/lein" do
  source "https://raw.github.com/technomancy/leiningen/2.3.2/bin/lein"
  mode 0755
  user "root"
  group "root"
end
execute "install_leiningen" do
  command "lein version"
  user pilot_username
  group pilot_username
  environment ({"HOME" => pilot_home_path})
  not_if "ls /home/english/.lein/self-installs/leiningen-2.3.2-standalone.jar"
end

# Git/SSH
directory "/etc/aerostat" do
  owner pilot_username
  group pilot_username
  mode 00744
end

cookbook_file "/etc/aerostat/id_rsa" do
  source "secrets/id_rsa" # .gitignored!
  owner pilot_username
  group pilot_username
  mode 00600
end

cookbook_file "/etc/aerostat/id_rsa.pub" do
  source "secrets/id_rsa.pub" # .gitignored!
  owner pilot_username
  group pilot_username
  mode 00644
end

cookbook_file "/etc/ssh/ssh_known_hosts" do
  source "secrets/ssh_known_hosts" # .gitignored!
  owner pilot_username
  group pilot_username
  mode 00744
end

file "/usr/local/bin/aerostat-ssh.sh" do
  owner pilot_username
  group pilot_username
  mode 00744
  content <<EOS
#!/bin/bash
/usr/bin/env ssh -i "/etc/aerostat/id_rsa" $1 $2
EOS
end

file "#{pilot_home_path}/.ssh/config" do
  owner pilot_username
  group pilot_username
  mode 00600
  content <<EOS
Host *
  IdentityFile /etc/aerostat/id_rsa
EOS
end

cookbook_file ".gitconfig" do
  path pilot_home_path + "/.gitconfig"
  source "gitconfig"
  owner pilot_username
  group pilot_username
  mode 00644
end

# Project repos
directory "#{pilot_home_path}/git" do
  action :create
  owner pilot_username
  group pilot_username
  mode 00700
end

git "#{pilot_home_path}/git/aerostat" do
  repository "git@gitlab.atomicobject.com:mike.english/aerostat.git"
  action :checkout
  user pilot_username
  group pilot_username
  ssh_wrapper "/usr/local/bin/aerostat-ssh.sh"
end

directory "#{pilot_home_path}/git/github" do
  action :create
  owner pilot_username
  group pilot_username
  mode 00700
end

link "#{pilot_home_path}/gh" do
  to "#{pilot_home_path}/git/github"
  user pilot_username
  group pilot_username
end


# Tmux
package "tmux"
cookbook_file ".tmux.conf" do
  path pilot_home_path + "/.tmux.conf"
  source "tmux.conf"
  owner pilot_username
  group pilot_username
  mode 00644
end
git "#{pilot_home_path}/git/github/tmux-colors-solarized/" do
  repository "https://github.com/seebi/tmux-colors-solarized"
  action :checkout
  user pilot_username
  group pilot_username
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
    :host_list => pilot_username,
  )
end
# copilot user
user copilot_username do
  home copilot_home_path
  shell "/bin/bash"
  supports :manage_home => true
end
directory "#{copilot_home_path}/.ssh" do
  owner copilot_username
  group copilot_username
  mode 00700
end
file "#{copilot_home_path}/.ssh/authorized_keys" do
  owner copilot_username
  group copilot_username
  mode 00600
end




# Editors
# Vim
package "vim"
# TODO: Vim config
git "#{pilot_home_path}/.vim" do
  repository "git@gitorious.atomicobject.com:vim-settings/colthorp.git"
  action :checkout
  user pilot_username
  group pilot_username
  ssh_wrapper "/usr/local/bin/aerostat-ssh.sh"
end
file "#{pilot_home_path}/.vimrc" do
  user pilot_username
  group pilot_username
  content = <<EOS
source ~/.vim/common-vimrc.vim
source ~/.vim/english-vimrc.vim
EOS
end
# Emacs
package "emacs23"
# TODO: Emacs config

# Essentials
package "cowsay"
package "figlet"

