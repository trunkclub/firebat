require 'mocks/constants'

class GetFlow < Flare::Flow
  step \
    MockService,
    :get_a_thing,
    {}
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
