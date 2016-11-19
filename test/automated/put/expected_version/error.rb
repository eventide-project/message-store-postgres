require_relative '../../automated_init'

context "Put" do
  context "Expected Version" do
    context "Does not match the stream version" do
      stream_name = Controls::StreamName.example
      write_event = Controls::EventData::Write.example

      position = Put.(write_event, stream_name)

      incorrect_stream_version = position  + 1

      test "Is an error" do
        assert proc { Put.(write_event, stream_name, expected_version: incorrect_stream_version ) } do
          raises_error? EventSource::ExpectedVersion::Error
        end
      end

      context "Event" do
        read_event = Get.(stream_name, position: incorrect_stream_version, batch_size: 1).first

        test "Is not written" do
          assert(read_event.nil?)
        end
      end
    end
  end
end
