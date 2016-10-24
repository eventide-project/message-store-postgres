require_relative '../automated_init'

context "Write" do
  stream_name = Controls::Stream.example
  write_event = Controls::EventData::Write.example

  written_position = Write.(write_event, )

  read_event = Get.(stream, position: written_position).first

  test "Got the event that was written" do
    assert(read_event.position == written_position)
  end
end
