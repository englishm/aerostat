# Vagrant

node.default['vagrant']['url'] = "http://files.vagrantup.com/packages/a40522f5fabccb9ddabad03d836e120ff5d14093/vagrant_1.3.5_x86_64.deb"
node.default['vagrant']['checksum'] = "db7d06f46e801523d97b6e344ea0e4fe942f630cc20ab1706e4c996872f8cd71"

include_recipe "vagrant"


# TODO: find out why these are installed to root user only.
vagrant_plugin "vagrant-omnibus"
vagrant_plugin "vagrant-aws"
vagrant_plugin "vagrant-digitalocean"
