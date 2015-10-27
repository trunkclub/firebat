require 'spec_helper'
ENV['DEBUG'] = 'true'
ENV['BASE_URL'] = 'http://localhost'
require './lib/firebat'
require 'mocks/mock_service'
require 'mocks/mock_flows'
require 'mocks/constants'

describe Firebat do
  let(:logger_double) { double.as_null_object }

  before do
    Firebat.logger = logger_double
  end

  it 'can get' do
    performs_a_get
    GetFlow.new.run!
  end

  it 'can post' do
    performs_a_post
    PostFlow.new.run!
  end

  it 'can put' do
    performs_a_put
    PutFlow.new.run!
  end

  it 'can patch' do
    performs_a_patch
    PatchFlow.new.run!
  end

  it 'can delete' do
    performs_a_delete
    DeleteFlow.new.run!
  end

  it 'can execute multiple steps' do
    performs_a_get
    performs_a_post
    performs_a_put
    performs_a_patch
    performs_a_delete
    CombinedFlow.new.run!
  end

  it 'allows logger override' do
    performs_a_get
    expect(logger_double).to receive(:log).at_least(:once)
    GetFlow.new.run!
  end

  it 'allows http adapter override' do
    expect(MockAdapter).to receive(:get)
    HttpOverrideFlow.new.run!
  end

  it 'can set headers' do
    performs_a_get
    expect(HTTParty).to receive(:post) do |url, params|
      expect(params.fetch(:headers)).to eq({'foo' => 'bar'})
    end
    SetHeadersFlow.new.run!
  end
end
