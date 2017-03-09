default_action :run

property :mount_point,    String, name_property: true
property :device_name,    String, required: true
property :fs_type,        String, default: 'ext4'
property :reserved_space, default: 0

action :run do
  execute "format #{device_name} as #{fs_type}" do
    command "mke2fs -j -m#{reserved_space} -F #{device_name} -t #{fs_type}"
    action :run
    not_if { `file -s #{device_name}` =~ /filesystem data/ }
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
