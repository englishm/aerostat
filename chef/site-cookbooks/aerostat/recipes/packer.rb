# Packer

ark 'packer' do
  url 'https://dl.bintray.com/mitchellh/packer/0.3.10_linux_amd64.zip'
  action :dump
  path '/usr/local/bin'
  creates '/usr/local/bin/packer'
end
