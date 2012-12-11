maintainer       "DreamHost"
maintainer_email "jeremy@dreamhost.com"
license          "Apache 2.0"
description      "The OpenStack Networking service Quantum."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.6"

%w{ ubuntu }.each do |os|
  supports os
end

%w{ osops-utils }.each do |dep|
  depends dep
end
