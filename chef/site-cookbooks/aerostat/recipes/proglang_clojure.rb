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
