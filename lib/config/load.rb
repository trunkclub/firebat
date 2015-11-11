require 'httparty'
require 'dotenv'
require 'logger'
require 'collector'
require 'runner'
require 'service'
require 'process'
require 'flow'

Dotenv.load

module Firebat
  DEBUG = ENV.fetch('DEBUG', false)
  BASE_URL = ENV.fetch('BASE_URL') { raise "BASE_URL must be defined in .env" }
end
