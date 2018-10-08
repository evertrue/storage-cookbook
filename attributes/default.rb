default['storage']['aws_api_user'] = 'Storage'

default['filesystem']['by_mountpoint'] = node['filesystem2']['by_mountpoint'] unless default['filesystem']['by_mountpoint'] || !node['filesystem2']
default['filesystem']['by_device'] = node['filesystem2']['by_device'] unless default['filesystem']['by_device'] || !node['filesystem2']
default['filesystem']['by_pair'] = node['filesystem2']['by_pair'] unless default['filesystem']['by_pair'] || !node['filesystem2']
