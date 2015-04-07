require 'spec_helper'

describe 'LVM Pool' do
  {
    '/dev/xvdb' => '/mnt/dev0',
    '/dev/xvdc' => '/mnt/dev1'
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

  describe file('/mnt') do
    it { is_expected.to_not be_mounted }
  end
end
