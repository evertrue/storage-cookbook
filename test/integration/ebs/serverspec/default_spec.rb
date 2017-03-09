require 'spec_helper'

describe 'LVM Pool' do
  describe file('/mnt/ebs0') do
    it do
      is_expected.to be_mounted.with(
        device: '/dev/xvde',
        type: 'ext4',
        options: {
          rw: true
        }
      )
    end
  end

  describe file('/mnt') do
    it { is_expected.to_not be_mounted }
  end
end
