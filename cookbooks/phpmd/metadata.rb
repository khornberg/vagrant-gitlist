maintainer       "Escape Studios"
maintainer_email "dev@escapestudios.com"
license          "MIT"
description      "Installs/Configures phpmd"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.2"

supports "ubuntu"
supports "debian"
supports "centos"
supports "redhat"
supports "fedora"
supports "scientific"
supports "amazon"

depends "php"
depends "composer"
depends "pdepend"