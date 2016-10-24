require_relative '../automated_init'

context "Put and Get" do
  stream = Controls::Stream.example
  write_event = Controls::EventData::Write.example

  written_position = Put.(write_event, stream.name)

  read_event = Get.(stream, position: written_position)[0]

  test "Got the event that was written" do
    assert(read_event.position == written_position)
  end
end
