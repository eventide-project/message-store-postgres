require_relative '../../automated_init'

context "Write" do
  context "Batch" do
    context "Expected Version" do
      stream_name = Controls::StreamName.example

      write_event = Controls::EventData::Write.example
      written_position = Write.(write_event, stream_name)

      write_event_1 = Controls::EventData::Write.example(data: { attribute: 'value_1' })
      write_event_2 = Controls::EventData::Write.example(data: { attribute: 'value_2' })

      batch = [write_event_1, write_event_2]

      Write.(batch, stream_name, expected_version: written_position)

      context "Individual Events are Written" do
        2.times do |i|
          read_event = Get.(stream_name, position: i + written_position, batch_size: 1).first

          test "Event #{i + 1}" do
            refute(read_event.nil?)
          end
        end
      end
    end
  end
end
