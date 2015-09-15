module Firebat
  class Runner
    attr_reader :service, :action, :options, :block

    def initialize(service:, action:, options: {}, block: nil)
      @service = service
      @action = action
      @options = options
      @block = block
    end
  end
end
