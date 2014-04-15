#
# Cookbook Name:: storage
# Recipe:: default
#
# Copyright (C) 2014 EverTrue, Inc.
#
# All rights reserved - Do Not Redistribute
#

# This recipe handles the mounting of additional volumes under various
# circumstances.

# Find all ephemeral block devices and mount them in subdirectories inside /mnt
if node['ec2'] &&
  node['ec2']['block_device_mapping_ephemeral1']
  Chef::Log.info('Running on an ec2 instance with multiple block devices.  ' \
    'Setting up ephemeral mounts.')
  fail 'Directory /mnt not empty' if Dir.entries('/mnt') - %w(lost+found . ..) != []

  e_block_devs = node['ec2'].select do |k, v|
    k =~ /^block_device_mapping_ephemeral.*/
  end

  dev_names = e_block_devs.map do |k, v|
    "/dev/#{v.sub(/^s/, 'xv')}"
  end

  mnt_device = node['filesystem'].find { |k, v| v['mount'] == '/mnt' }

  unless mnt_device.nil?
    mount '/mnt' do
      fstype mnt_device.last['fs_type']
      device mnt_device.first
      action :umount
    end
  end

  ephemeral_mounts = []

  dev_names.each_with_index do |dev_name, i|
    mount_point = "/mnt/dev#{i}"

    directory mount_point do
      recursive true
    end

    mount mount_point do
      device dev_name
      fstype node['filesystem'][dev_name]['fs_type']
      action :mount
    end

    ephemeral_mounts << mount_point
  end

  node.set['et_base']['ephemeral_mounts'] = ephemeral_mounts
else
  Chef::Log.info('Not a recognized hypervisor type.  Not mounting any volumes.')
end
