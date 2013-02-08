# https://github.com/opscode-cookbooks
# http://community.opscode.com/cookbooks/
include_recipe "apt"
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_deflate"
#include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_rewrite"
#include_recipe "mysql"
#include_recipe "mysql::server"
include_recipe "php"
#include_recipe "php::module_mysql"
include_recipe "git"
#include_recipe "subversion"
#include_recipe "openssl"
include_recipe "ant"
	# depends on java and ark
include_recipe "composer"

# http://community.opscode.com/cookbooks/php
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

    # git "/location to clone to" do
    #   repository "git://github.com/klaussilveira/gitlist.git"
    #   reference "master"
    #   action :sync
    # end