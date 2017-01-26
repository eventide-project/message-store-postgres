require_relative '../automated_init'

context "Get Last" do
  stream_name = Controls::Put.(instances: 2)

  write_event = Controls::EventData::Write.example

  position = Put.(write_event, stream_name)

  last_event = Get::Last.(stream_name)

  test "Gets the last event in the stream" do
    assert(last_event.data == write_event.data)
  end
end
