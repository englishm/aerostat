# Go Programming Language

ark 'go' do
  version '1.2rc3'
  url 'http://go.googlecode.com/files/go1.2rc3.linux-amd64.tar.gz'
  action :install
  has_binaries ['bin/go', 'bin/godoc', 'bin/gofmt']
  not_if do ::File.exists?('/usr/local/bin/go') end
end

directory "#{$pilot_home_path}/go" do
  owner $pilot_username
end
