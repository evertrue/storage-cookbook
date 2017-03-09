require 'spec_helper'

describe 'LVM Pool' do
  {
    '/dev/nvme0n1' => '/mnt/dev0',
    '/dev/xvde' => '/mnt/ebs0'
  }.each do |device, mountpoint|
    describe file(mountpoint) do
      it do
        is_expected.to be_mounted.with(
          device: device,
          type: 'ext4',
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
