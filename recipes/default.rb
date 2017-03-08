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

if Chef::VersionConstraint.new('< 12.0.0').include? Chef::VERSION
  fail 'This cookbook requires Chef 12'
end

Chef::Log.debug("Storage info: #{node['storage'].inspect}")

include_recipe 'et_fog'

storage = EverTools::Storage.new(node)
ephemeral_mounts = []

if File.exist?('/proc/mounts') && File.readlines('/proc/mounts').grep(%r{/mnt/dev0}).size.zero?

  Chef::Log.info '/mnt/dev0 not already mounted.  Proceeding...'

  if node['ec2'] &&
     node['ec2']['block_device_mapping_ephemeral0'] &&
     storage.instance_store_volumes?

    # Unmount anything we find mounted at '/mnt' (as long as it's empty)

    Chef::Log.info 'EC2 ephemeral storage detected.'

    fail 'Directory /mnt not empty' if Dir.entries('/mnt') - %w(lost+found . ..) != []

    unless storage.mnt_device.nil?
      m = mount '/mnt' do
        fstype storage.mnt_device.last['fs_type']
        device storage.mnt_device.first
        action :nothing
      end
      m.run_action(:umount)
      m.run_action(:disable)
    end
  end

  unless storage.dev_names.empty?
    # This function formats newly discovered devices, mounts them, then stores
    # their name in our collector array ("ephemeral_mounts").

    Chef::Log.info 'Usable storage devices discovered.'
    Chef::Log.debug "Storage devices: #{storage.dev_names.inspect}"

    ephemeral_mounts = storage.dev_names.each_with_index.map do |dev_name, i|
      mount_point = "/mnt/dev#{i}"

      storage_format_mount mount_point do
        device_name dev_name
        action :nothing
      end.run_action(:run)

      mount_point
    end
  end
else
  # If we find /mnt/dev0 already mounted (which implies that this recipe has
  # already been run), just make sure the attribute gets populated.

  Chef::Log.info '/mnt/dev0 already mounted.'
  ephemeral_mounts =
    storage.dev_names.each_with_index.map { |_dev_name, i| "/mnt/dev#{i}" }

  # Shipped with Chef 12.0.0
  # https://github.com/chef/chef/pull/1719
  mount '/mnt' do
    action :disable
    device '/dev/xvdb'
    only_if { !node['storage']['ephemeral_mounts'].size.zero? }
  end
end

# Populate the attribute with whatever we gathered during this convergence.
if ephemeral_mounts.any?
  node.set['storage']['ephemeral_mounts'] = ephemeral_mounts

  Chef::Log.info 'Configured these ephemeral mounts: ' +
    node['storage']['ephemeral_mounts'].join(' ')
else
  Chef::Log.info 'No ephemeral mounts were found'
  node.rm('storage', 'ephemeral_mounts')
end

include_recipe 'storage::ebs' if node['storage']['ebs_volumes']
