name             "pdepend"
maintainer       "Escape Studios"
maintainer_email "dev@escapestudios.com"
license          "MIT"
description      "Installs/Configures pdepend"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

supports "ubuntu"
supports "debian"
supports "centos"
supports "redhat"
supports "fedora"
supports "scientific"
supports "amazon"

depends "php"
depends "composer"