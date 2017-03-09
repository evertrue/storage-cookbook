require 'spec_helper'

describe 'LVM Pool' do
  {
    '/dev/xvdb' => { mountpoint: '/mnt/dev0', fstype: 'ext3' },
    '/dev/xvdc' => { mountpoint: '/mnt/dev1', fstype: 'ext3' },
    '/dev/xvde' => { mountpoint: '/mnt/ebs0', fstype: 'ext4' }
  }.each do |device, prop|
    describe file(prop[:mountpoint]) do
      it do
        is_expected.to be_mounted.with(
          device: device,
          type: prop[:fstype],
          options: {
            rw: true
          }
        )
      end
    end
  end

  describe file('/mnt') do
    it { is_expected.to_not be_mounted }
  end
end
