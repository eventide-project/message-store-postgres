require_relative '../../automated_init'

context "Put" do
  context "Event" do
    context "Expected Version" do
      stream_name = Controls::StreamName.example(category: 'testPutEventExpectedVersion')

      write_event_1 = Controls::EventData::Write.example(data: { attribute: 'value_1' })

      position = Put.(write_event_1, stream_name)

      write_event_2 = Controls::EventData::Write.example(data: { attribute: 'value_2' })

      Put.(write_event_2, stream_name, expected_version: position)

      read_event = Get.(stream_name, position: position + 1).first

      test "Got the event that was written" do
        assert(read_event.data[:attribute] == 'value_2')
      end
    end
  end
end
