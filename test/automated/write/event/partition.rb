require_relative '../../automated_init'

context "Write" do
  context "Event" do
    context "Partition" do
      stream_name = Controls::StreamName.example(category: 'testWriteEventPartition')
      partition = Controls::Partition.example

      write_event = Controls::EventData::Write.example(data: { attribute: 'some_value' })

      position = Write.(write_event, stream_name, partition: partition)

      read_event = Get.(stream_name, position: position, partition: partition).first

      test "Got the event that was written" do
        assert(read_event.data[:attribute] == "some_value")
      end
    end
  end
end
