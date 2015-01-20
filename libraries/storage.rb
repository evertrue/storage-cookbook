module EverTools
  class Storage
    def dev_names
      names = []
      if @node['ec2'] &&
        @node['ec2']['block_device_mapping_ephemeral0']
        Chef::Log.debug('Using ec2 storage')
        names = ec2_dev_names
      elsif @node['etc']['passwd']['vagrant']
        Chef::Log.debug('Using vagrant storage')
        names = vagrant_dev_names
      else
        fail 'Can\'t figure out what kind of node we\'re running on.'
      end
      Chef::Log.debug 'Discovered ephemeral devices: ' + names.join(', ')
      names
    end

    def mnt_device
      @node['filesystem'].find { |_k, v| v['mount'] == '/mnt' }
    end

    def instance_store_volumes?
      f = fog.flavors.get(@node['ec2']['instance_type'])
      fail "Unrecognized flavor: #{@node['ec2']['instance_type']}" if f.nil?
      !f.instance_store_volumes.zero?
    end

    def initialize(node)
      @node = node
    end

    private

    def fog
      @fog ||= begin
        require 'fog'

        aws_keys = Chef::EncryptedDataBagItem.load(
          @node['storage']['credentials']['data_bag'],
          @node['storage']['credentials']['data_bag_item']
        )[@node['storage']['aws_api_user']]

        Fog::Compute::AWS.new(
          aws_access_key_id: aws_keys['access_key_id'],
          aws_secret_access_key: aws_keys['secret_access_key']
        )
      end
    end

    def local
      non_root_bds = @node['block_device'].select { |bd, _conf| bd != 'sda' }
      r = non_root_bds.select do |_bd, bd_conf|
        bd_conf['model'] == 'VBOX HARDDISK'
      end
      Chef::Log.info('No additional block devices found') if r.size.zero?
      r
    end

    def ec2_dev_names
      e_block_devs = @node['ec2'].select do |k, _v|
        k =~ /^block_device_mapping_ephemeral.*/
      end

      e_block_devs.map do |_k, v|
        "/dev/#{v.sub(/^s/, 'xv')}"
      end
    end

    def vagrant_dev_names
      local.map do |bd, _conf|
        "/dev/#{bd}"
      end
    end
  end
end
