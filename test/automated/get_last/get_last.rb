require_relative '../automated_init'

context "Get Last" do
  stream_name, _ = Controls::Put.(instances: 2)

  write_message = Controls::MessageData::Write.example

  position = Put.(write_message, stream_name)

  last_message = Get::Last.(stream_name)

  test "Gets the last message in the stream" do
    assert(last_message.data == write_message.data)
  end
end
