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

  e_block_devs = node['ec2'].select do |k, _v|
    k =~ /^block_device_mapping_ephemeral.*/
  end

  dev_names = e_block_devs.map do |_k, v|
    "/dev/#{v.sub(/^s/, 'xv')}"
  end

  mnt_device = node['filesystem'].find { |_k, v| v['mount'] == '/mnt' }

  if mnt_device.nil?
    Chef::Log.info 'No /mnt devices found in node[:filesystem]:'
    Chef::Log.info node['filesystem'].inspect
  else
    mount '/mnt' do
      fstype mnt_device.last['fs_type']
      device mnt_device.first
      action :umount
    end
  end
elsif node['etc']['passwd']['vagrant']
  Chef::Log.info 'Using Vagrant storage'
  local_storage = node['block_device'].select { |bd, _conf| bd != 'sda' }.select do |_bd, bd_conf|
    bd_conf['model'] == 'VBOX HARDDISK'
  end
  dev_names = local_storage.map do |bd, _conf|
    "/dev/#{bd}"
  end
  Chef::Log.info 'Discovered ephemeral devices: ' + dev_names.join(', ')
else
  Chef::Log.info('Not a recognized hypervisor type.  Not mounting any volumes.')
end

node.set['storage']['ephemeral_mounts'] = dev_names.each_with_index.map do |dev_name, i|
  mount_point = "/mnt/dev#{i}"

  execute "format #{dev_name} as ext3" do
    command "mke2fs -j -F #{dev_name} -t ext3"
    action :nothing
    not_if { `file -s #{dev_name}` =~ /filesystem data/ }
  end.run_action(:run)

  directory mount_point do
    recursive true
    action :nothing
  end.run_action(:create)

  mount mount_point do
    device dev_name
    # fstype `file -s #{dev_name}`[/\b\w+\b filesystem data/].split.first
    action :nothing
  end.run_action(:mount)

  mount_point
end if dev_names && !dev_names.empty?

Chef::Log.info 'Configured these ephemeral mounts: ' +
  node['storage']['ephemeral_mounts'].inspect
