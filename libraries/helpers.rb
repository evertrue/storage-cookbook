require 'net/http'

module Storage
  class Helpers
    def self.iam_profile_instance?
      Net::HTTP.get_response(
        URI 'http://169.254.169.254/2016-09-02/meta-data/iam/'
      ).code.to_i == 200
    end

    # Workaround for AWS and server device name mismatch
    def self.ebs_storage_device_name(node, conf)
      case conf['device']
      when '/dev/xvde'
        node['ec2']['instance_type'] =~ /^t3\./ ? '/dev/nvme1n1' : conf['device']
      else
        conf['device']
      end
    end
  end
end
