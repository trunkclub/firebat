module Flare
  class Process
    class << self
      def flows
        @_flows ||= []
      end

      def flow(klass, options = {})
        flows << { klass: klass, options: options }
      end

      def run!
        prior_result = {}
        flows.each do |flow|
          params = prior_result.merge(flow[:options])
          prior_result = flow[:klass].send(:run!, params)
        end
      end
    end
  end
end
