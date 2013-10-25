# Support for programming language

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

# Development Libraries
# Libraries often needed to compile gem native extensions, etc.
package 'libsqlite3-dev'

# Python
include_recipe "python"

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
  user $pilot_username
  group $pilot_username
  environment ({"HOME" => $pilot_home_path})
  not_if "ls #{$pilot_home_path}/.lein/self-installs/leiningen-2.3.2-standalone.jar"
end
