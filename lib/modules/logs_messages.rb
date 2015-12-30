module LogsMessages
  extend self

  @@_logger = Logger.new

  def logger=(logger)
    @@_logger = logger
  end

  def log(message)
    @@_logger.log(message)
  end

  def log_error(error)
    @@_logger.log_error(error)
  end
end
