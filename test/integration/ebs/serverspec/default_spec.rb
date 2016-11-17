require 'spec_helper'

describe 'LVM Pool' do
  {
    '/dev/xvde' => '/mnt/ebs0'
  }.each do |device, mountpoint|
    describe file(mountpoint) do
      it do
        is_expected.to be_mounted.with(
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

describe 'storage' do
  describe file '/mnt/ebs0' do
    it { is_expected.to be_mounted.with device: '/dev/xvde' }
  end
end
