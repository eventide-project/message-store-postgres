require_relative '../automated_init'

context "Put" do
  context "Partition" do
    stream_name = Controls::StreamName.example(category: 'testPutPartition')
    partition = Controls::Partition.example

    write_event = Controls::EventData::Write.example

    written_position = Put.(write_event, stream_name, partition: partition)

    read_event = Get.(stream_name, partition: partition, position: written_position).first

    test "Got the event that was written" do
      assert(read_event.position == written_position)
    end
  end
end
