require 'modules/uses_http'

module Flare
  class Service
    include UsesHttp

    def self.set_headers(headers = {})
      @@_headers = headers
    end

    def headers
      (@@_headers ||= {})
    end

    def base_url
      BASE_URL
    end
  end
end
