#
# Cookbook Name:: phpmd
# Attributes:: default
#
# Copyright 2013, Escape Studios
#

default[:phpmd][:install_method] = "pear"
default[:phpmd][:version] = "latest"

#composer install only
default[:phpmd][:prefix] = "/usr/bin"