require_relative '../../../automated_init'

context "Write" do
  context "Batch" do
    context "Expected Version" do
      stream_name = Controls::StreamName.example

      write_event = Controls::EventData::Write.example
      position = Write.(write_event, stream_name)

      write_event_1 = Controls::EventData::Write.example
      write_event_2 = Controls::EventData::Write.example

      batch = [write_event_1, write_event_2]

      Write.(batch, stream_name, expected_version: position)

      context "Individual Events are Written" do
        2.times do |i|
          read_event = Get.(stream_name, position: i + 1, batch_size: 1).first
          write_event = batch[i]

          test "Event #{i + 1}" do
            assert(read_event.data == write_event.data)
          end
        end
      end
    end
  end
end
