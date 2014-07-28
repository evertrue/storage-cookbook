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

storage = EverTools::Storage.new(node)

if File.readlines('/proc/mounts').grep(%r{/mnt/dev0}).size.zero?

  if node['ec2'] &&
    node['ec2']['block_device_mapping_ephemeral0']
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
    node.set['storage']['ephemeral_mounts'] =
      storage.dev_names.each_with_index.map do |dev_name, i|
        mount_point = "/mnt/dev#{i}"

        storage_format_mount mount_point do
          device_name dev_name
          action :nothing
        end.run_action(:run)

        mount_point
      end
  end
else
  node.set['storage']['ephemeral_mounts'] =
    storage.dev_names.each_with_index.map { |_dev_name, i| "/mnt/dev#{i}" }
end

Chef::Log.info 'Configured these ephemeral mounts: ' +
  node['storage']['ephemeral_mounts'].join(' ')
