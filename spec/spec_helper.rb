ENV['RACK_ENV'] = 'test'
require 'simplecov'
SimpleCov.start

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

def performs_a_get
  expect(HTTParty).to receive(:get).with("#{MockService.new.base_url}/a-thing", anything)
end

def performs_a_post
  expect(HTTParty).to receive(:post).with(
    "#{MockService.new.base_url}/a-thing",
    hash_including(
      body: FirebatMocks::OPTIONS
    )
  )
end

def performs_a_put
  expect(HTTParty).to receive(:put).with(
    "#{MockService.new.base_url}/a-thing",
    hash_including(
      body: FirebatMocks::OPTIONS
    )
  )
end

def performs_a_patch
  expect(HTTParty).to receive(:patch).with(
    "#{MockService.new.base_url}/a-thing",
    hash_including(
      body: FirebatMocks::OPTIONS
    )
  )
end

def performs_a_delete
  expect(HTTParty).to receive(:delete).with(
    "#{MockService.new.base_url}/a-thing",
    anything
  )
end
