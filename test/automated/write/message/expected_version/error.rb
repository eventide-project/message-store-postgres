require_relative '../../../automated_init'

context "Write" do
  context "Message" do
    context "Expected Version" do
      context "Does not match the stream version" do
        stream_name = Controls::StreamName.example

        write_message = Controls::MessageData::Write.example
        position = Write.(write_message, stream_name)

        incorrect_stream_version = position  + 1

        test "Is an error" do
          assert proc { Write.(write_message, stream_name, expected_version: incorrect_stream_version ) } do
            raises_error? ExpectedVersion::Error
          end
        end

        context "Message" do
          read_message = Get.(stream_name, position: incorrect_stream_version, batch_size: 1).first

          test "Is not written" do
            assert(read_message.nil?)
          end
        end
      end
    end
  end
end
