require 'adapters/httparty_adapter'

module Firebat
  class Service
    def initialize(adapter = HTTPartyAdapter)
      @_adapter = adapter
    end

    def set_headers(headers = {})
      @@_headers = headers
    end

    def headers
      (@@_headers ||= {})
    end

    def base_url
      BASE_URL
    end

    [:post, :get, :put, :patch, :delete].each do |verb|
      define_method(verb) do |url, body = {}|
        @_adapter.send(verb, base_url, url, body, headers).tap do |response|
          if DEBUG
            if response.success?
              Firebat.log(response.inspect)
            else
              Firebat.log_error(response.inspect)
            end
          end
        end
      end
    end
  end
end
