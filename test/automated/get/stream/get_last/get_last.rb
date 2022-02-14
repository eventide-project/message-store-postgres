require_relative '../../../automated_init'

context "Get" do
  context "Stream" do
    context "Last" do
      stream_name, _ = Controls::Put.(instances: 2)

      write_message = Controls::MessageData::Write.example

      Put.(write_message, stream_name)

      last_message = Get::Stream::Last.(stream_name)

      test "Gets the last message in the stream" do
        assert(last_message.data == write_message.data)
      end
    end
  end
end
