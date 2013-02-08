# Recipes from http://community.opscode.com/cookbooks/
# Used knife cookbook site download to get the recipes
include_recipe "apt"
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_deflate"
include_recipe "apache2::mod_rewrite"
include_recipe "php"
include_recipe "git"
include_recipe "ant" # depends on java and ark
include_recipe "composer"
include_recipe "pdepend::composer"
include_recipe "phpunit"
include_recipe "phpcpd"
include_recipe "phploc"
include_recipe "phpmd::composer"

execute "disable-default-site" do
  command "sudo a2dissite default"
  notifies :reload, resources(:service => "apache2"), :delayed
end

web_app "project" do
  template "project.conf.erb"
  notifies :reload, resources(:service => "apache2"), :delayed
end

bash "setup-www" do
	code "sudo mkdir /var/www/projects /var/www/gitlist;
		  sudo chown -R vagrant /var/www/projects;
		  cd /var/www/projects"
end

# Comment the git and bash sections out if you want to build Gitlist from your local machine.
git "/var/www/projects/gitlist" do
  repository "git://github.com/klaussilveira/gitlist.git"
  reference "master"
  action :sync
end

bash "setup-gitlist" do
	code "cd /var/www/projects/gitlist;
		  ant;
		  sudo tar -zxvf build/gitlist.tar.gz -C /var/www/gitlist/;
		  cd /var/www/gitlist;
		  sudo chmod 777 cache;
		  sudo cp config.ini-example config.ini;
		  sudo chown -R www-data /var/www/gitlist;
		  sudo chgrp -R www-data /var/www/gitlist"
end

# Uncomment this section if you want to build Gitlist from your local machine.
# This requires that the vagrant files are in the same directory as where you cloned Gitlist.
# If you want to include your own config.ini file change the cp command that copies the config file.

# bash "setup-gitlist-local" do
# 	code "sudo cp -r /vagrant/* /var/www/projects/gitlst/
# 		  cd /vagrant;
# 		  ant;
# 		  sudo tar -zxvf build/gitlist.tar.gz -C /var/www/gitlist/;
# 		  cd /var/www/gitlist;
# 		  sudo chmod 777 cache;
# 		  sudo cp config.ini-example config.ini;
# 		  sudo chown -R www-data /var/www/gitlist;
# 		  sudo chgrp -R www-data /var/www/gitlist"
# end

#sdg