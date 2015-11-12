module CollectsInput
  extend self

  @@_collector = Collector.new

  def collector=(collector)
    @@_collector = collector
  end

  def collect_input(prompt)
    @@_collector.collect_input(prompt) do |value|
      yield(value) if block_given?
    end
  end
end
