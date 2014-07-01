module EverTools
  class Storage
    def dev_names
      names = []
      if @node['ec2'] &&
        @node['ec2']['block_device_mapping_ephemeral0']
        names = ec2_dev_names
      elsif @node['etc']['passwd']['vagrant']
        names = vagrant_dev_names
      end
      Chef::Log.debug 'Discovered ephemeral devices: ' + names.join(', ')
      names
    end

    def mnt_device
      @node['filesystem'].find { |_k, v| v['mount'] == '/mnt' }
    end

    def initialize(node)
      @node = node
    end

    private

    def local
      non_root_bds = @node['block_device'].select { |bd, _conf| bd != 'sda' }
      non_root_bds.select do |_bd, bd_conf|
        bd_conf['model'] == 'VBOX HARDDISK'
      end
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
      storage.local.map do |bd, _conf|
        "/dev/#{bd}"
      end
    end
  end
end
