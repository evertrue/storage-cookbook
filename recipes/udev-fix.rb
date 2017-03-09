#
# Cookbook Name:: storage
# Recipe:: default
#
# Copyright (C) 2017 EverTrue, Inc.
#
# All rights reserved - Do Not Redistribute
#

#
# This cookbook applies the fix for this UDEV memory hotadd bug:
#
# https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1668129
#
# ...and can be safely removed once that fix is merged upstream.

execute 'udevadm trigger' do
  command 'udevadm trigger'
  action :nothing
end

cookbook_file '/lib/udev/rules.d/40-vm-hotadd.rules' do
  only_if do
    platform_family?('debian') &&
      node['platform_version'].to_i >= 16 &&
      File.exist?('/lib/udev/rules.d/40-vm-hotadd.rules')
  end
  notifies :run, 'execute[udevadm trigger]'
end
