actions :run
default_action :run

attribute :mount_point,
          kind_of: String,
          name_attribute: true
attribute :device_name,
          kind_of: String,
          required: true
attribute :fs_type,
          kind_of: String,
          default: 'ext3'
attribute :reserved_space,
          default: 0
