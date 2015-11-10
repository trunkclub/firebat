module Firebat
  class Process
    class << self
      def flows
        @_flows ||= []
      end

      def flow(klass, options = {})
        flows << { instance: klass.new, options: options }
      end

      def remove_flow(flow_klass)
        @_flows = flows.reject do |flow|
          flow[:instance].instance_of?(flow_klass)
        end
      end

      def run!
        prior_result = {}
        flows.each do |flow|
          params = prior_result.merge(flow[:options])
          prior_result = flow[:instance].send(:run!, params) || {}
        end
      end
    end
  end
end
