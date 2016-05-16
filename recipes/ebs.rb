node['storage']['ebs_volumes'].each_with_index do |(name, conf), i|
  aws_ebs_volume name do
    conf.each { |key, value| send(key, value) }
    action %i(create attach)
  end

  mount_point = "/mnt/ebs#{i}"

  storage_format_mount mount_point do
    device_name conf['device']
  end

  node.set['storage']['ebs_mounts'] = (node['storage']['ebs_mounts'] || []) | [mount_point]
end
