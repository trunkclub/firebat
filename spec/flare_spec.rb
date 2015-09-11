require './lib/flare'
require 'mocks/mock_service'
require 'mocks/mock_flows'
require 'mocks/constants'

describe Flare do
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
end
