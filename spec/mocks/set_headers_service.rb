class SetHeadersService < Firebat::Service
  def self.to_sym
    :mock_service
  end

  def base_url
    'http://flare.test'
  end

  def get_a_thing(options = {})
    get('/a-thing').tap do |response|
      set_headers({
        'foo' => 'bar'
      })
    end
  end

  def post_a_thing(options = {})
    post('/a-thing', options)
  end
end
