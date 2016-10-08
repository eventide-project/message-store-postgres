ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= 'fatal'

puts RUBY_DESCRIPTION

require_relative '../init.rb'
require 'event_source/postgres/controls'

require 'test_bench'; TestBench.activate

require 'pp'

include EventSource
include EventSource::Postgres
