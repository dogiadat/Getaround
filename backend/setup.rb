require "byebug"
require "json"
require "virtus"
require "logger"
require "../lib/data_translator"
Dir["../models/*.rb"].each {|file| require file }
