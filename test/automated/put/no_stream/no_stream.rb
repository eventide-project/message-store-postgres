require_relative '../../automated_init'

controls = EventStream::Postgres::Controls

context "Put" do
  context "No Stream" do
    context "For a stream that doesn't exist" do
      stream_name = controls::StreamName.example
      write_event = controls::EventData::Write.example

      stream_position = Put.(stream_name, write_event)

      test "Ensures that the event written is the first event in the stream" do
        assert(stream_position == 0)
      end
    end
  end
end
