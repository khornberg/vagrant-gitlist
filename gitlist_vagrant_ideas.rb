# Chef commands for Vagrant GitList

# knife cookbook site download <cookbook>
# knife cookbook site search <term>

# http://community.opscode.com/cookbooks/php
# 	http://docs.opscode.com/lwrp_php.html
# 	http://phpqatools.org/

# pear config-set auto_discover 1
# pear install pear.phpqatools.org/phpqatools

# http://community.opscode.com/cookbooks/composer
# http://community.opscode.com/cookbooks/ant
# http://community.opscode.com/cookbooks/git

# http://files.vagrantup.com/precise32.box

# http://jyates.github.com/2011/11/26/vagrant-chef-tips.html

# egrajeda
# Simplist to get a LAMP stack started
# Requires some configuration
#######################################################
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "lucid32"

  config.vm.forward_port 80, 8080
  config.vm.forward_port 3306, 8081

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      "mysql" => { "server_root_password" => "" }
    }
    chef.add_recipe "apt"
    chef.add_recipe "apache2"
    chef.add_recipe "apache2::mod_php5"
    chef.add_recipe "mysql"
    chef.add_recipe "mysql::server"
    chef.add_recipe "php"
    chef.add_recipe "php::module_mysql"
  end
end

# ymainier
#######################################################
Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. For a detailed explanation
  # and listing of configuration options, please view the documentation
  # online.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.add_recipe("vagrant_main")
    chef.json.merge!({
    :mysql => {
      :server_root_password => "root"
    }
  })
  end

  config.vm.forward_port(80, 8080)
  config.vm.forward_port(3306, 3306)
end


#vagrant_main
include_recipe "apt"
include_recipe "apache2"
include_recipe "mysql::server"
include_recipe "php::php5"

# Some neat package (subversion is needed for "subversion" chef ressource)
%w{ debconf php5-xdebug subversion  }.each do |a_package|
  package a_package
end

# get phpmyadmin conf
cookbook_file "/tmp/phpmyadmin.deb.conf" do
  source "phpmyadmin.deb.conf"
end
bash "debconf_for_phpmyadmin" do
  code "debconf-set-selections /tmp/phpmyadmin.deb.conf"
end
package "phpmyadmin"

s = "dev-site"
site = {
  :name => s, 
  :host => "www.#{s}.com", 
  :aliases => ["#{s}.com", "dev.#{s}-static.com"]
}

# Configure the development site
web_app site[:name] do
  template "sites.conf.erb"
  server_name site[:host]
  server_aliases site[:aliases]
  docroot "/vagrant/public/"
end  

# Add site info in /etc/hosts
bash "info_in_etc_hosts" do
  code "echo 127.0.0.1 #{site[:host]} #{site[:aliases]} >> /etc/hosts"
end

# Retrieve webgrind for xdebug trace analysis
subversion "Webgrind" do
  repository "http://webgrind.googlecode.com/svn/trunk/"
  revision "HEAD"
  destination "/var/www/webgrind"
  action :sync
end

# Add an admin user to mysql
execute "add-admin-user" do
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -e \"" +
      "CREATE USER 'myadmin'@'localhost' IDENTIFIED BY 'myadmin';" +
      "GRANT ALL PRIVILEGES ON *.* TO 'myadmin'@'localhost' WITH GRANT OPTION;" +
      "CREATE USER 'myadmin'@'%' IDENTIFIED BY 'myadmin';" +
      "GRANT ALL PRIVILEGES ON *.* TO 'myadmin'@'%' WITH GRANT OPTION;\" " +
      "mysql"
  action :run
  only_if { `/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -D mysql -r -N -e \"SELECT COUNT(*) FROM user where user='myadmin' and host='localhost'"`.to_i == 0 }
  ignore_failure true
end

# r8
#######################################################
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # Set box configuration
  config.vm.box = "lucid32"
  config.vm.box_url = "http://files.vagrantup.com/lucid32.box"

  # Assign this VM to a host-only network IP, allowing you to access it via the IP.
  config.vm.network :hostonly, "33.33.33.10"

  # Enable provisioning with chef solo, specifying a cookbooks path (relative
  # to this Vagrantfile), and adding some recipes and/or roles.
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.data_bags_path = "data_bags"
    chef.add_recipe "vagrant_main"

    chef.json.merge!({
      "mysql" => {
        "server_root_password" => "vagrant"
      },
      "oh_my_zsh" => {
        :users => [
          {
            :login => 'vagrant',
            :theme => 'blinks',
            :plugins => ['git', 'gem']
          }
        ]
      }
    })
  end
end

#vagrant_main
include_recipe "apt"
include_recipe "git"
include_recipe "oh-my-zsh"
include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_ssl"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "apache2::mod_php5"

# Install packages
%w{ debconf vim screen mc subversion curl tmux make g++ libsqlite3-dev }.each do |a_package|
  package a_package
end

# Install ruby gems
%w{ rake mailcatcher }.each do |a_gem|
  gem_package a_gem
end

# Generate selfsigned ssl
execute "make-ssl-cert" do
  command "make-ssl-cert generate-default-snakeoil --force-overwrite"
  ignore_failure true
  action :nothing
end

# Initialize sites data bag
sites = []
begin
  sites = data_bag("sites")
rescue
  puts "Sites data bag is empty"
end

# Configure sites
sites.each do |name|
  site = data_bag_item("sites", name)

  # Add site to apache config
  web_app site["host"] do
    template "sites.conf.erb"
    server_name site["host"]
    server_aliases site["aliases"]
    docroot site["docroot"]?site["docroot"]:"/vagrant/public/#{site["host"]}"
  end  

   # Add site info in /etc/hosts
   bash "hosts" do
     code "echo 127.0.0.1 #{site["host"]} #{site["aliases"].join(' ')} >> /etc/hosts"
   end
end

# Disable default site
apache_site "default" do
  enable false  
end

# Install phpmyadmin
cookbook_file "/tmp/phpmyadmin.deb.conf" do
  source "phpmyadmin.deb.conf"
end
bash "debconf_for_phpmyadmin" do
  code "debconf-set-selections /tmp/phpmyadmin.deb.conf"
end
package "phpmyadmin"

# Install Xdebug
php_pear "xdebug" do
  action :install
end
template "#{node['php']['ext_conf_dir']}/xdebug.ini" do
  source "xdebug.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
  notifies :restart, resources("service[apache2]"), :delayed
end

# Install Webgrind
git "/var/www/webgrind" do
  repository 'git://github.com/jokkedk/webgrind.git'
  reference "master"
  action :sync
end
template "#{node[:apache][:dir]}/conf.d/webgrind.conf" do
  source "webgrind.conf.erb"
  owner "root"
  group "root"
  mode 0644
  action :create
  notifies :restart, resources("service[apache2]"), :delayed
end

# Install php-curl
package "php5-curl" do
  action :install
end

# Get eth1 ip
eth1_ip = node[:network][:interfaces][:eth1][:addresses].select{|key,val| val[:family] == 'inet'}.flatten[0]

# Setup MailCatcher
bash "mailcatcher" do
  code "mailcatcher --http-ip #{eth1_ip} --smtp-port 25"
end
template "#{node['php']['ext_conf_dir']}/mailcatcher.ini" do
  source "mailcatcher.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
  notifies :restart, resources("service[apache2]"), :delayed
end

# Fix deprecated php comments style in ini files
bash "deploy" do
  code "sudo perl -pi -e 's/(\s*)#/$1;/' /etc/php5/cli/conf.d/*ini"
  notifies :restart, resources("service[apache2]"), :delayed
end

# Install Percona Toolkit
bash "percona-key" do
  # Install percona repo key. 
  # We can't use 'apt' recipe, because this command should be run with sudo
  code "sudo apt-key adv --keyserver keys.gnupg.net --recv 1C4CBDCDCD2EFD2A"
end
apt_repository "percona" do
  uri "http://repo.percona.com/apt"
  components ["main"]
  distribution "lucid"
end
bash "apt-get-update" do
  code "sudo apt-get update"
end
%w{ libmysqlclient16 percona-toolkit }.each do |a_package|
  package a_package
end

# Install Composer
bash "composer" do
  code <<-EOH
    curl -s https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
  EOH
end