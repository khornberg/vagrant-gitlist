# GitList Vagrant Setup

#### Provisions a vagrant VM to build and test GitList.


## Software

- [Precise32](http://files.vagrantup.com/precise32.box)
- ant
- apt
- apache2
- apache2::mod_php5
- apache2::mod_deflate
- apache2::mod_rewrite
- php
- git
- composer
- [phpaqtools](pear.phpaqtools.org)
> - PHPUnit
> - PHPLOC
> - PHP Copy/Paste Detector
> - PHP_CodeSniffer
> - PHP_Depend
> - PHP_CodeBrowser

## Setup

Vhosts setup?
What do I want to do?
localhost/ is probably simplist without having others have to edit /etc/hosts file

Set up to look at /build file for the docroot
url: localhost:8080/gitlist

Edits config.ini file
mkdir /public  somewhere
git clone git://github.com/klaussilveira/gitlist.git

## Build

How do I get this to build once everything is complete?
Uses local files and writes to /build folder