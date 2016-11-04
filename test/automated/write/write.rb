require_relative '../automated_init'

context "Write" do
  stream_name = Controls::StreamName.example
  write_event = Controls::EventData::Write.example

  written_position = Write.(write_event, stream_name)

  read_event = Get.(stream_name, position: written_position).first

  test "Got the event that was written" do
    assert(read_event.position == written_position)
  end
end
