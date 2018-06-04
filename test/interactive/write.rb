require_relative 'interactive_init'

message_data = Controls::MessageData::Write.example
stream_name = 'testWriteIsolation'

write = Write.build

i = 0
loop do
  position = write.(message_data, stream_name)
  puts "i: #{i}, p: #{position}"
  i += 1
end

