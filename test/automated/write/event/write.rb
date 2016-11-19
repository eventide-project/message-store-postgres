require_relative '../../automated_init'

context "Write" do
  context "Event" do
    stream_name = Controls::StreamName.example(category: 'testWriteEvent')

    write_event = Controls::EventData::Write.example(data: { attribute: 'some_value' })

    position = Write.(write_event, stream_name)

    read_event = Get.(stream_name, position: position).first

    test "Got the event that was written" do
      assert(read_event.data[:attribute] == "some_value")
    end
  end
end
