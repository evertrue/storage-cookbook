use_inline_resources

action :run do
  execute "format #{new_resource.device_name} as #{new_resource.fs_type}" do
    command "mke2fs -j -F #{new_resource.device_name} -t " \
      "#{new_resource.fs_type}"
    action :run
    not_if { `file -s #{new_resource.device_name}` =~ /filesystem data/ }
  end

  directory new_resource.mount_point do
    recursive true
    action :create
  end

  mount new_resource.mount_point do
    device new_resource.device_name
    action :mount
  end
end
