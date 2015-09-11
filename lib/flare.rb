require 'config/load'
require 'modules/logs_messages'

module Flare
  include LogsMessages
  @@_logger = Logger.new

  def logger=(logger)
    @@_logger = logger
  end
  module_function :logger=

  def log(message)
    @@_logger.log(message)
  end
  module_function :log
end
