require 'spec_helper'

describe 'storage::default' do
  context '/mnt/dev0 is already mounted' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['storage'] = {}
        allow(File).to receive(:readlines).and_return(
          ['/dev/xvdb /mnt/dev0 ext3 rw,relatime,data=ordered 0 0\n']
        )
      end.converge(described_recipe)
    end

    let(:evertools) do
      double('evertools', dev_names: ['/dev/xvdb', '/dev/xvdc'])
    end

    before { expect(EverTools::Storage).to receive(:new).and_return(evertools) }

    it 'disables mount /mnt' do
      expect(chef_run).to disable_mount('/mnt')
    end
  end
end
