require_relative 'test_init'

# stream_name = Controls::StreamName.example

stream_name = 'someStream-123'
write_message = Controls::MessageData::Write.example

position = Put.(write_message, stream_name)

pp Get.(stream_name, position: position).first
