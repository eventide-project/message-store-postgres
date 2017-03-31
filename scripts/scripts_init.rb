ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= '_min'

puts RUBY_DESCRIPTION

init_file = File.expand_path('../init.rb', __dir__)
# if File.exist?('init.rb')
if File.exist?(init_file)
  require_relative '../init'
end

require 'event_source/postgres/database'

puts "SCRIPTS INIT"
