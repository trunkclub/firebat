module LogsMessages
  extend self

  @@_logger = Logger.new

  def logger=(logger)
    @@_logger = logger
  end

  def log(message)
    @@_logger.log(message)
  end
end
