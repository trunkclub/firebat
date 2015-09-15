module Firebat
  class HTTPartyAdapter
    class << self
      def post(base_url, url, body, headers = {})
        HTTParty.post(base_url + url, {
          body: body,
          headers: headers
        })
      end

      def get(base_url, url, query = {}, headers = {})
        HTTParty.get(base_url + url, {
          headers: headers,
          query: query
        })
      end

      def put(base_url, url, body = {}, headers = {})
        HTTParty.put(base_url + url, {
          body: body,
          headers: headers
        })
      end

      def patch(base_url, url, body = {}, headers = {})
        HTTParty.patch(base_url + url, {
          body: body,
          headers: headers
        })
      end

      def delete(base_url, url, body = {}, headers = {})
        HTTParty.delete(base_url + url, {
          headers: headers
        })
      end
    end
  end
end
