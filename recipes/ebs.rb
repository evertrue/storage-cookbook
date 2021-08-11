unless Storage::Helpers.iam_profile_instance? && !node['storage']['use_storage_aws_credentials']
  creds = data_bag_item('secrets', 'aws_credentials')['Storage']
end

node['storage']['ebs_volumes'].each_with_index do |(name, conf), i|
  aws_ebs_volume name do
    conf.each { |key, value| send(key, value) }
    if creds
      aws_access_key creds['access_key_id']
      aws_secret_access_key creds['secret_access_key']
    end
    action %i(create attach)
  end

  mount_point = "/mnt/ebs#{i}"

  storage_format_mount mount_point do
    device_name Storage::Helpers.ebs_storage_device_name(node, conf)
  end

  node.set['storage']['ebs_mounts'] = (node['storage']['ebs_mounts'] || []) | [mount_point]
end
