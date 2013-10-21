# Editors

# Vim
package "vim"
git "#{$pilot_home_path}/.vim" do
  repository node["aerostat"]["vimconfig_repo_url"]
  action :checkout
  user $pilot_username
  group $pilot_username
  ssh_wrapper "/usr/local/bin/aerostat-ssh.sh"
end
file "#{$pilot_home_path}/.vimrc" do
  user $pilot_username
  group $pilot_username
  content <<EOS
source ~/.vim/common-vimrc.vim
source ~/.vim/#{$pilot_username}-vimrc.vim
EOS
end
# Emacs
package "emacs23"
# TODO: Emacs config
