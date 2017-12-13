default_action :run

property :mount_point,    String, name_property: true
property :device_name,    String, required: true
property :fs_type,        String, default: 'ext4'
property :reserved_space, default: 0

action :run do
  execute "format #{new_resource.device_name} as #{new_resource.fs_type}" do
    command "mke2fs -j -m#{new_resource.reserved_space} -F #{new_resource.device_name} -t #{new_resource.fs_type}"
    action :run
    not_if { `file -s #{new_resource.device_name}` =~ /filesystem data/ }
  end

  directory mount_point do
    recursive true
    action :create
  end

  mount mount_point do
    device device_name
    action %i(mount enable)
  end
end
