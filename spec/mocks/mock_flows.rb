require 'mocks/constants'
require 'mocks/mock_service'
require 'mocks/http_override_service'
require 'mocks/set_headers_service'

class HttpOverrideFlow < Flare::Flow
  step \
    HttpOverrideService,
    :get_a_thing
end

class GetFlow < Flare::Flow
  step \
    MockService,
    :get_a_thing
end

class PostFlow < Flare::Flow
  step \
    MockService,
    :post_a_thing,
    FlareMocks::OPTIONS
end

class PutFlow < Flare::Flow
  step \
    MockService,
    :put_a_thing,
    FlareMocks::OPTIONS
end

class PatchFlow < Flare::Flow
  step \
    MockService,
    :patch_a_thing,
    FlareMocks::OPTIONS
end

class DeleteFlow < Flare::Flow
  step \
    MockService,
    :delete_a_thing
end

class CombinedFlow < Flare::Flow
  step \
    MockService,
    :get_a_thing,
    {}

  step \
    MockService,
    :post_a_thing,
    FlareMocks::OPTIONS

  step \
    MockService,
    :put_a_thing,
    FlareMocks::OPTIONS

  step \
    MockService,
    :patch_a_thing,
    FlareMocks::OPTIONS

  step \
    MockService,
    :delete_a_thing
end

class SetHeadersFlow < Flare::Flow
  step \
    SetHeadersService,
    :get_a_thing

  step \
    SetHeadersService,
    :post_a_thing
end
