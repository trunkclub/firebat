module Flare
  module UsesHttp
    def post(url, body)
      HTTParty.post(base_url + url, {
        body: body,
        headers: headers
      }).tap { |r| Flare.log r if DEBUG }
    end

    def get(url, query = {})
      HTTParty.get(base_url + url, {
        headers: headers,
        query: query
      }).tap { |r| Flare.log r if DEBUG }
    end

    def put(url, body = {})
      HTTParty.put(base_url + url, {
        body: body,
        headers: headers.merge({ 'Content-Type' => 'application/json' })
      }).tap { |r| Flare.log r if DEBUG }
    end

    def patch(url, body = {})
      HTTParty.patch(base_url + url, {
        body: body,
        headers: headers
      }).tap { |r| Flare.log r if DEBUG }
    end

    def delete(url)
      HTTParty.delete(base_url + url, {
        headers: headers
      }).tap { |r| Flare.log r if DEBUG }
    end
  end
end
