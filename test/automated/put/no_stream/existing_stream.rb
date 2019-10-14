require_relative '../../automated_init'

context "Put" do
  context "No Stream" do
    context "Existing Stream" do
      stream_name = Controls::StreamName.example

      write_message_1 = Controls::MessageData::Write.example
      write_message_2 = Controls::MessageData::Write.example

      Put.(write_message_1, stream_name)

      test "Is an error" do
        assert_raises ExpectedVersion::Error do
          Put.(write_message_2, stream_name, expected_version: NoStream.name)
        end
      end
    end
  end
end
