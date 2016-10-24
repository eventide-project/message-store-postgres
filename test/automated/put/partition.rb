require_relative '../automated_init'

context "Put and Get to another table name" do
  stream = Controls::Stream.example
  write_event = Controls::EventData::Write.example

  written_position = Put.(write_event, stream.name, partition: Controls::Partition.example)

  read_event = Get.(stream, partition: Controls::Partition.example, position: written_position).first

  test "Got the event that was written" do
    assert(read_event.position == written_position)
  end
end
