require_relative '../../automated_init'

context "Write" do
  context "Event" do
    stream_name = Controls::StreamName.example

    write_event = Controls::EventData::Write.example

    position = Write.(write_event, stream_name)

    read_event = Get.(stream_name, position: position).first

    test "Got the event that was written" do
      assert(read_event.data == write_event.data)
    end
  end
end
