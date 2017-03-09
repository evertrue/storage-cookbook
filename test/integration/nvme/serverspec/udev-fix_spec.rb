require 'spec_helper'

describe 'storage::udev-fix' do
  if os[:family] == 'ubuntu' && os[:release].to_i >= 16
    describe file '/lib/udev/rules.d/40-vm-hotadd.rules' do
      describe '#content' do
        subject { super().content }
        it { is_expected.to match(/^# SUBSYSTEM=="memory/) }
      end
    end
  else
    describe file '/lib/udev/rules.d/40-vm-hotadd.rules' do
      it { is_expected.to_not be_file }
    end
  end
end
