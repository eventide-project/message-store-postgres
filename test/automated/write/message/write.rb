require_relative '../../automated_init'

context "Write" do
  context "Message" do
    stream_name = Controls::StreamName.example

    write_message = Controls::MessageData::Write.example

    position = Write.(write_message, stream_name)

    read_message = Get.(stream_name, position: position).first

    test "Got the message that was written" do
      assert(read_message.data == write_message.data)
    end
  end
end
