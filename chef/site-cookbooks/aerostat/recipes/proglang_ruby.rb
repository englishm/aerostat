# Ruby

node.default[:rbenv][:group_users] = [$pilot_username]
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
rbenv_gem "pivotal_git_scripts" do
  ruby_version "2.0.0-p247"
end
rbenv_gem "pivotal_git_scripts" do
  ruby_version "1.9.3-p392"
end
rbenv_gem "pivotal_git_scripts" do
  ruby_version "1.8.7-p371"
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

# bundler config
directory "#{$pilot_home_path}/.bundle" do
  owner $pilot_username
end
cookbook_file "bundle_config" do
  path $pilot_home_path + "/.bundle/config"
  source "bundle_config"
  owner $pilot_username
  group $pilot_username
  mode 00644
end

