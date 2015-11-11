class Collector
  def collect_input(prompt)
    puts prompt
    if block_given?
      yield(gets.squeeze(' ').strip.to_s)
    end
  end
end
