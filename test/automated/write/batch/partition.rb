require_relative '../../automated_init'

context "Write" do
  context "Batch" do
    context "Partition" do
      stream_name = Controls::StreamName.example

      write_event_1 = Controls::EventData::Write.example
      write_event_2 = Controls::EventData::Write.example

      batch = [write_event_1, write_event_2]

      partition = Controls::Partition.example

      Write.(batch, stream_name, partition: partition)

      context "Individual Events are Written" do
        2.times do |i|
          read_event = Get.(stream_name, partition: partition, position: i, batch_size: 1).first

          test "Event #{i + 1}" do
            refute(read_event.nil?)
          end
        end
      end
    end
  end
end
