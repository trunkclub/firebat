require 'httparty'
require 'dotenv'

Dotenv.load

module Flare
  class Logger
    def log(message)
      puts(message)
    end
  end

  @@_logger = Logger.new

  def logger=(logger)
    @@_logger = logger
  end
  module_function :logger=

  def log(message)
    @@_logger.log(message)
  end
  module_function :log

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
      (@@_headers ||= {})
    end

    def base_url
      BASE_URL
    end

    def post(url, body)
      HTTParty.post(base_url + url, {
        body: body,
        headers: headers
      }).tap { |r| Flare.log r if DEBUG }
    end

    def get(url, query = {})
      HTTParty.get(base_url + url, {
        headers: headers,
        query: query
      }).tap { |r| Flare.log r if DEBUG }
    end

    def put(url, body = {})
      HTTParty.put(base_url + url, {
        body: body,
        headers: headers.merge({ 'Content-Type' => 'application/json' })
      }).tap { |r| Flare.log r if DEBUG }
    end

    def patch(url, body = {})
      HTTParty.patch(base_url + url, {
        body: body,
        headers: headers
      }).tap { |r| Flare.log r if DEBUG }
    end
  end

  class Block
    def initialize(runner:, action:, options: {})
      @runner = runner
      @action = action
      @options = options
    end
  end

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

      def result(result)
        @_result = result
      end
    end

    KNOWN_BEHAVIOR_KEYS = [
      :times,
      :with
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

    def self.run!(input = {})
      @_input = input

      steps.each do |step|
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
          runner = runners[step.service.to_sym] ||= step.service.new

          Flare.log \
            %Q(
              #{'='*100}
              #{runner.to_s} => #{step.action.to_s}
              #{options.inspect}
              #{'='*100}
            )

          result = runner.send(step.action, options)
          step.block.call(result) if step.block
        end
      end

      @_result.respond_to?(:call) ? @_result.call : @_result
    end
  end
end
