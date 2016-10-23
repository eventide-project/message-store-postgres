require_relative '../automated_init'

context "Put and Get" do
  stream = Controls::Stream.example
  write_event = Controls::EventData::Write.example

  written_stream_position = Put.(stream.name, write_event)

  read_event = Get.(stream, stream_position: written_stream_position).first

  test "Got the event that was written" do
    assert(read_event.stream_position == written_stream_position)
  end
end
