require './lib/flare'
require 'mocks/mock_service'
require 'mocks/mock_flows'
require 'mocks/constants'

module Flare
  DEBUG = true
end

describe Flare do
  let(:logger_double) { double.as_null_object }

  before do
    Flare.logger = logger_double
  end

  it 'can get' do
    performs_a_get
    GetFlow.run!
  end

  it 'can post' do
    performs_a_post
    PostFlow.run!
  end

  it 'can put' do
    performs_a_put
    PutFlow.run!
  end

  it 'can patch' do
    performs_a_patch
    PatchFlow.run!
  end

  it 'can delete' do
    performs_a_delete
    DeleteFlow.run!
  end

  it 'can execute multiple steps' do
    performs_a_get
    performs_a_post
    performs_a_put
    performs_a_patch
    performs_a_delete
    CombinedFlow.run!
  end

  it 'allows logger override' do
    performs_a_get
    expect(logger_double).to receive(:log).at_least(:once)
    GetFlow.run!
  end

  it 'allows http adapter override' do
    expect(MockAdapter).to receive(:get)
    HttpOverrideFlow.run!
  end
end
