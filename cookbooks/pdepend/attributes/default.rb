#
# Cookbook Name:: pdepend
# Attributes:: default
#
# Copyright 2013, Escape Studios
#

default[:pdepend][:install_method] = "pear"
default[:pdepend][:version] = "latest"

#composer install only
default[:pdepend][:prefix] = "/usr/bin"