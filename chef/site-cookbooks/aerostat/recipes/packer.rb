# Packer

ark 'packer' do
  url 'https://dl.bintray.com/mitchellh/packer/0.4.0_linux_amd64.zip'
  action :dump
  path '/usr/local/bin'
  creates '/usr/local/bin/packer'
end

# QEMU

package 'qemu'
package 'qemu-kvm'

