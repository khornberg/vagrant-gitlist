# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # Use Ubuntu 12.04 if already downloaded, otherwise download from the offical location
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  # Forward port for the webserver
  config.vm.forward_port 80, 8080
#  config.vm.forward_port 3306, 8081

  config.vm.provision :chef_solo do |chef|

    # https://github.com/opscode-cookbooks
    # http://community.opscode.com/cookbooks/
    chef.add_recipe "apt"
    chef.add_recipe "apache2"
    chef.add_recipe "apache2::mod_php5"
    chef.add_recipe "apache2::mod_deflate"
    #chef.add_recipe "apache2::mod_ssl"
    chef.add_recipe "apache2::mod_rewrite"
    #chef.add_recipe "mysql"
    #chef.add_recipe "mysql::server"
    chef.add_recipe "php"
    #chef.add_recipe "php::module_mysql"
    chef.add_recipe "git"
    #chef.add_recipe "subversion"
    #chef.add_recipe "openssl"
    chef.add_recipe "ant"
    chef.add_recipe "composer"
    
    # http://community.opscode.com/cookbooks/php
    chef.add_recipe "phpunit"
    chef.add_recipe "phpcpd"
    chef.add_recipe "phploc"
    chef.add_recipe "phpmd"
    chef.add_recipe "pdepend"
    

#    https://github.com/awildeep/liesIToldMyKids/tree/master/custom_cookbooks
#    <name>/recipes/default.rb
#      chef.add_recipe "apache2_vhosts"
#      chef.add_recipe "php_modules"


#     pear config-set auto_discover 1
#     pear install pear.phpqatools.org/phpqatools

#    php_pear_channel "pear.phpaqtools.org" do
#      action :discover
#    end
#
#    php_pear "phpaqtools" do
#      action :install
#    end


#    chef.json.merge!({
#      :mysql => {
#        :server_root_password => "root"
#      }
#    })
  
    
    git "/location to clone to" do
      repository "git://github.com/klaussilveira/gitlist.git"
      reference "master"
      action :sync
    end

  end
end


#sdg