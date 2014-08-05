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

include_recipe 'et_fog'

storage = EverTools::Storage.new(node)

if storage.instance_store_volumes? &&
  File.readlines('/proc/mounts').grep(%r{/mnt/dev0}).size.zero?

  if node['ec2'] &&
    node['ec2']['block_device_mapping_ephemeral0']

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

  # Uncomment the following code when https://github.com/opscode/chef/pull/1719
  # is actually merged and shipped.
  #
  # mount '/mnt' do
  #   action :disable
  #   device '/dev/xvdb'
  #   only_if { !node['storage']['ephemeral_mounts'].size.zero? }
  # end
end

Chef::Log.info 'Configured these ephemeral mounts: ' +
  node['storage']['ephemeral_mounts'].join(' ') if node['storage']
