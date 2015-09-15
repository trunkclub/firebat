require 'mocks/constants'
require 'mocks/mock_service'
require 'mocks/http_override_service'
require 'mocks/set_headers_service'

class HttpOverrideFlow < Firebat::Flow
  step \
    HttpOverrideService,
    :get_a_thing
end

class GetFlow < Firebat::Flow
  step \
    MockService,
    :get_a_thing
end

class PostFlow < Firebat::Flow
  step \
    MockService,
    :post_a_thing,
    FirebatMocks::OPTIONS
end

class PutFlow < Firebat::Flow
  step \
    MockService,
    :put_a_thing,
    FirebatMocks::OPTIONS
end

class PatchFlow < Firebat::Flow
  step \
    MockService,
    :patch_a_thing,
    FirebatMocks::OPTIONS
end

class DeleteFlow < Firebat::Flow
  step \
    MockService,
    :delete_a_thing
end

class CombinedFlow < Firebat::Flow
  step \
    MockService,
    :get_a_thing,
    {}

  step \
    MockService,
    :post_a_thing,
    FirebatMocks::OPTIONS

  step \
    MockService,
    :put_a_thing,
    FirebatMocks::OPTIONS

  step \
    MockService,
    :patch_a_thing,
    FirebatMocks::OPTIONS

  step \
    MockService,
    :delete_a_thing
end

class SetHeadersFlow < Firebat::Flow
  step \
    SetHeadersService,
    :get_a_thing

  step \
    SetHeadersService,
    :post_a_thing
end
