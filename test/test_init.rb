ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= '_min'

puts RUBY_DESCRIPTION

require_relative '../init'
require 'message_store/controls'

require 'test_bench'; TestBench.activate

include MessageStore
