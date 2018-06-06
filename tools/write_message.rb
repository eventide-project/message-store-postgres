#!/usr/bin/env ruby

ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= '_min'

puts RUBY_DESCRIPTION

require_relative '../init'

require 'message_store/postgres/controls'

include MessageStore
include MessageStore::Postgres

instances = Integer(ENV['INSTANCES'] || 1)
stream_name = ENV['STREAM_NAME']

puts
puts "Writing #{instances} messages"
puts "- - -"

instances.times do |i|
  stream_name, position = Controls::Put.(stream_name: stream_name)
  puts "Instance: #{i}, Position: #{position}, Stream Name: #{stream_name}"
end

puts
