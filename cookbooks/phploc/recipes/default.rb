#
# Cookbook Name:: phploc
# Recipe:: default
#
# Copyright 2013, Escape Studios
#

case node[:phploc][:install_method]
	when "pear"
		include_recipe "phploc::pear"
	when "composer"
		include_recipe "phploc::composer"
end