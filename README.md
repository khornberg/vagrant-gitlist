# GitList Vagrant Setup

#### Provisions a vagrant VM to build and test GitList.


## Software

- [Precise32](http://files.vagrantup.com/precise32.box)
- ant
    - java
    - ark
- apt
- apache2
    - apache2::mod_php5
    - apache2::mod_deflate
    - apache2::mod_rewrite
- php
- git
- composer
- PHP_Depend
- PHPUnit
- PHPLOC
- PHP Copy/Paste Detector
- PHP_Mess Detector

## Setup
Requires vagrant to be installed and uses the box name precise32. If you have another base box to use you can change that in the Vagrantfile.

In a folder say gitlist-build run `vagrant init`
Clone this repository by running `git clone git://github.com/khornberg/vagrant-gitlist.git`
Run `cp vagrant-gitlist/* .`
Run `vagrant up`

## Build
<<<<<<< HEAD
The recipe will clone the latest [master from klaussilveria](http://github.com/klaussilveria/gitlist), build it, and set up gitlist.
=======
The recipe will clone the latest [master from klaussilveria](http://github.com/klaussivleria/gitlist), build it, and set up gitlist.
>>>>>>> 95f31544edaeb6cfb5fa4daea33069da3d13688d
You can access the built GitList at http://localhost:8080.
You will be looking at the latest clone of GitList from which you build GitList.

## Local Build
You can build from your clone of GitList by un/commenting out a section in the `cookbooks/vagrant_main/recipes/default.rb` [file](/cookbooks/vagrant_main/recipes/default.rb)