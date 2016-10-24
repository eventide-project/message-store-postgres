require_relative '../../automated_init'

context "Put" do
  context "No Stream" do
    context "For a stream that doesn't exist" do
      stream_name = Controls::StreamName.example
      write_event = Controls::EventData::Write.example

      position = Put.(write_event, stream_name)

      test "Ensures that the event written is the first event in the stream" do
        assert(position == 0)
      end
    end
  end
end
