class MockService < Firebat::Service
  def base_url
    'http://flare.test'
  end

  def get_a_thing(options = {})
    get('/a-thing')
  end

  def post_a_thing(options = {})
    post('/a-thing', options)
  end

  def put_a_thing(options = {})
    put('/a-thing', options)
  end

  def patch_a_thing(options = {})
    patch('/a-thing', options)
  end

  def delete_a_thing(options = {})
    delete('/a-thing')
  end
end
