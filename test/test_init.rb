ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= '_min'

puts RUBY_DESCRIPTION

require_relative '../init.rb'
require 'event_source/postgres/controls'

require 'test_bench'; TestBench.activate

include MessageStore
include MessageStore::Postgres
