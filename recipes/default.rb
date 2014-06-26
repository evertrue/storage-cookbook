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

Chef::Log.debug("Storage info: #{node['storage'].inspect}")

if node['storage'] == {}
  storage = EverTools::Storage.new(node)

  if node['ec2'] &&
    node['ec2']['block_device_mapping_ephemeral1']
    Chef::Log.info('Using ec2 ephemeral storage')

    fail 'Directory /mnt not empty' if Dir.entries('/mnt') - %w(lost+found . ..) != []

    unless storage.mnt_device.nil?
      mount '/mnt' do
        fstype storage.mnt_device.last['fs_type']
        device storage.mnt_device.first
        action :nothing
      end.run_action(:umount)
    end
  elsif node['etc']['passwd']['vagrant']
    Chef::Log.info('Using Vagrant storage')
  else
    Chef::Log.debug('Not a recognized hypervisor type.  Doing nothing.')
  end

  unless storage.dev_names.empty?
    node.set['storage']['ephemeral_mounts'] = storage.dev_names.each_with_index.map do |dev_name, i|
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
    end
  end

  Chef::Log.info 'Configured these ephemeral mounts: ' +
    node['storage']['ephemeral_mounts'].inspect if node['storage']['ephemeral_mounts']
else
  Chef::Log.info "Storage already configured: #{node['storage'].inspect}"
end
