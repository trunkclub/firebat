class MockAdapter
  def self.get(base_url, url, query = {}, headers)

  end
end

class HttpOverrideService < Flare::Service
  def initialize
    super(MockAdapter)
  end

  def self.to_sym
    :http_override_service
  end

  def base_url
    'http://flare.test'
  end

  def get_a_thing(options = {})
    get('/a-thing')
  end
end
