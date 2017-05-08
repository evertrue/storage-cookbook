require 'net/http'

module Storage
  class Helpers
    def self.iam_profile_instance?
      Net::HTTP.get_response(
        URI 'http://169.254.169.254/2016-09-02/meta-data/iam/'
      ).code.to_i == 200
    end
  end
end
