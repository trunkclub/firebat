require 'config/load'
require 'modules/logs_messages'
require 'modules/collects_input'
require 'rake'

module Firebat
  extend LogsMessages
  extend CollectsInput
end
