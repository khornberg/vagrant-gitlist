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

Clone this repository and run Vagrant to build GitList
    `git clone git://github.com/khornberg/vagrant-gitlist.git`
    `vagrant up`

## Build
The recipe will clone the latest master from klaussilveria, build it, and set up gitlist.
You can access the built Gitlist at `http://localhost:8080`.
You will be looking at the latest clone of GitList from which you build GitList.

## Local Build
You can build from your clone of Gitlist by un/commenting out a section in the [cookbooks/vagrant_main/recipes/default.rb](/blob/master/cookbooks/vagrant_main/recipes/default.rb)
