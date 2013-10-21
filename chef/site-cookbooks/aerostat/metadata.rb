name              "aerostat"
maintainer        "Mike English"
maintainer_email  "mike.english@gmail.com"
license           "MIT"
description       "An cookbook"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.0.1"

recipe "default", "Tethered"

%w{ debian }.each do |os|
    supports os
end

depends 'rbenv'
depends 'sudo'
