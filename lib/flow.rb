module Firebat
  class Flow
    ENABLE_OVERRIDES = ENV.fetch('ENABLE_OVERRIDES', false)
    ENABLE_REQUIRED_INPUT = ENV.fetch('ENABLE_REQUIRED_INPUT', false)

    class << self
      def required_inputs
        @_required_inputs ||= []
      end

      def overridable_inputs
        @_overridable_inputs ||= []
      end

      def steps
        @_steps ||= []
      end

      def runners
        @_runners ||= {}
      end

      def required_input(*names)
        names.each do |name|
          required_inputs << name
        end
      end

      def overridable_input(*names)
        names.each do |name|
          overridable_inputs << name
        end
      end

      def step(service, action, options = {}, block = nil)
        steps << Runner.new(
          service: service,
          action: action,
          options: options,
          block: block
        )
      end
    end

    KNOWN_BEHAVIOR_KEYS = [
      :times,
      :with
    ]

    def non_behavioral_options(options = {})
      options.reject do |k, v|
        KNOWN_BEHAVIOR_KEYS.include?(k)
      end
    end

    def resolve(v)
      if v.is_a?(Firebat::Runner)
        self.class.runners[v.service.to_s] ||= v.service.new
        self.class.runners[v.service.to_s].send(v.action)
      elsif v.is_a?(Symbol)
        self.send(v)
      elsif v.respond_to?(:call)
        v.call(self)
      else
        v
      end
    end

    def resolve_options(options)
      options.inject({}) do |h, (k, v)|
        h.merge(k => resolve(v))
      end
    end

    def collect_required_input(input = {})
      return input unless ENABLE_REQUIRED_INPUT
      remaining_keys = self.class.required_inputs - input.keys
      remaining_keys = remaining_keys + input.select do |k,v|
        v.nil? && self.class.required_inputs.include?(k)
      end.keys
      remaining_keys.each do |key|
        Firebat.collect_input "Value for #{key}?" do |value|
          input[key] = value
        end
      end

      input
    end

    def collect_override_input(input = {})
      return input unless ENABLE_OVERRIDES

      self.class.overridable_inputs.each do |key|
        value = input[key]
        Firebat.collect_input "Override value for #{key}? (Current: #{value}) (y/n)" do |answer|
          if answer.downcase == 'y'
            Firebat.collect_input "Value for #{key}?" do |value|
              input[key] = value
            end
          end
        end
      end

      input
    end

    def collect_input(input = {})
      input = collect_required_input(input)
      input = collect_override_input(input)
      input
    end

    def run!(input = {})
      @_input = collect_input(input)

      self.class.steps.each do |step|
        options = resolve(step.options)
        times = options.fetch(:times, 1).to_i
        with = options.fetch(:with, nil)

        set, operation =
          if with
            [resolve(with), :each]
          else
            [times, :times]
          end

        set.send(operation) do |item|
          options = options.merge(item) if operation == :each
          options = resolve_options(non_behavioral_options(options))
          runner = self.class.runners[step.service.to_s] ||= step.service.new

          Firebat.log \
            %Q(
              #{'='*100}
              #{runner.to_s} => #{step.action.to_s}
              #{options.inspect}
              #{'='*100}
            ) if DEBUG

          result = runner.send(step.action, options)
          if step.block && step.block.respond_to?(:call)
            step.block.call(result)
          elsif step.block && step.block.is_a?(Symbol)
            self.send(step.block, result)
          else
            result
          end
        end
      end

      self.result if self.respond_to?(:result)
    end
  end
end
