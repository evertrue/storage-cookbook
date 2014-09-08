require 'spec_helper'

describe 'LVM Pool' do
  {
    '/dev/sdb' => '/mnt/dev0',
    '/dev/sdc' => '/mnt/dev1'
  }.each do |device, mountpoint|
    describe file(mountpoint) do
      it do
        should be_mounted.with(
          device: device,
          type: 'ext3',
          options: {
            rw: true
          }
        )
      end
    end
  end
end
