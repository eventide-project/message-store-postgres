require_relative '../../automated_init'

context "Put" do
  context "No Stream" do
    context "For a stream that doesn't exist" do
      stream_name = Controls::StreamName.example
      write_message = Controls::MessageData::Write.example

      position = Put.(write_message, stream_name)

      test "Ensures that the message written is the first message in the stream" do
        assert(position == 0)
      end
    end
  end
end
