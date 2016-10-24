require_relative '../automated_init'

context "Put and Get to another table name" do
  stream = Controls::Stream.example
  write_event = Controls::EventData::Write.example

  written_stream_position = Put.(stream.name, write_event, partition: Controls::Partition.example)

  read_event = Get.(stream, partition: Controls::Partition.example, stream_position: written_stream_position).first

  test "Got the event that was written" do
    assert(read_event.stream_position == written_stream_position)
  end
end
