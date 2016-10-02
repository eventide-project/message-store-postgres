require_relative '../automated_init'

context "Put and Get" do
  stream_name = Controls::StreamName.example
  write_event = Controls::EventData::Write.example

  written_stream_position = Put.(stream_name, write_event)

  read_event = Get.(stream_name: stream_name, stream_position: written_stream_position)[0]

  test "Got the event that was written" do
    assert(read_event.stream_position == written_stream_position)
  end
end
