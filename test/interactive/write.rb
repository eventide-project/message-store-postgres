require_relative 'interactive_init'

stream_name = 'testWriteIsolation'

message_data_1 = Controls::MessageData::Write.example(data: { attribute: 1 })
message_data_2 = Controls::MessageData::Write.example(data: { attribute: 2 })
batch = [message_data_1, message_data_2]

write = Write.build

i = 0
loop do
  position = write.(batch, stream_name)
  puts "i: #{i}, p: #{position}"
  i += 1
end

