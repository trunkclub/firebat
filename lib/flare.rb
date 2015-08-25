require 'httparty'

module Flare
  class Runner
    attr_reader :service, :action, :options, :block

    def initialize(service:, action:, options: {}, block: nil)
      @service = service
      @action = action
      @options = options
      @block = block
    end
  end

  class Service
    BASE_URL = ENV.fetch('BASE_URL') { raise "BASE_URL must be defined in .env" }
    DEBUG = ENV.fetch('DEBUG', false)

    def self.set_headers(headers = {})
      @@_headers = headers
    end

    def headers
      @@_headers ||= {}
    end

    def base_url
      BASE_URL
    end

    def post(url, body)
      HTTParty.post(base_url + url, {
        body: body,
        headers: headers
      }).tap { |r| puts r if DEBUG }
    end

    def get(url)
      HTTParty.get(base_url + url, {
        headers: headers
      }).tap { |r| puts r if DEBUG }
    end

    def put(url, body)
      HTTParty.put(base_url + url, {
        body: body,
        headers: headers
      }).tap { |r| puts r if DEBUG }
    end
  end

  class Block
    def initialize(runner:, action:, options: {})
      @runner = runner
      @action = action
      @options = options
    end
  end

  class Flow
    class << self
      def blocks
        @_blocks ||= []
      end

      def block(runner, action, options = {})
        blocks << Flare::Block.new(
          runner: runner,
          action: action,
          options: options
        )
      end

      def steps
        @_steps ||= []
      end

      def runners
        @_runners ||= {}
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
      :times
    ]

    def self.non_behavioral_options(options = {})
      options.reject do |k, v|
        KNOWN_BEHAVIOR_KEYS.include?(k)
      end
    end

    def self.resolve(v)
      if v.is_a?(Flare::Runner)
        runners[v.service.to_sym] ||= v.service.new
        runners[v.service.to_sym].send(v.action)
      elsif v.respond_to?(:call)
        v.call
      else
        v
      end
    end

    def self.resolve_options(options)
      options.inject({}) do |h, (k, v)|
        h.merge(k => resolve(v))
      end
    end

    def self.run!
      steps.each do |step|
        times = step.options.fetch(:times, 1).to_i
        times.times do
          options = resolve_options(non_behavioral_options(step.options))

          runner = runners[step.service.to_sym] ||= step.service.new
          result = runner.send(step.action, options)
          step.block.call(result) if step.block
        end
      end
    end
  end
end  
