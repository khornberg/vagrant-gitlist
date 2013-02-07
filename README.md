# README for a newly created project.

There are a couple of things you should do first, before you can use all of Git's power:

  * Add a remote to this project: in the Cloud9 IDE command line, you can execute the following commands
    `git remote add [remote name] [remote url (eg. 'git@github.com:/ajaxorg/node_chat')]` [Enter]
  * Create new files inside your project
  * Add them to to Git by executing the following command
    `git add [file1, file2, file3, ...]` [Enter]
  * Create a commit which can be pushed to the remote you just added
    `git commit -m 'added new files'` [Enter]
  * Push the commit the remote
    `git push [remote name] master` [Enter]

That's it! If this doesn't work for you, please visit the excellent resources from [Github.com](http://help.github.com) and the [Pro Git](http://http://progit.org/book/) book.
If you can't find your answers there, feel free to ask us via Twitter (@cloud9ide), [mailing list](groups.google.com/group/cloud9-ide) or IRC (#cloud9ide on freenode).

Happy coding!

# GitList Vagrant Setup

Provisions a vagrant VM to build and test GitList.
- - -

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