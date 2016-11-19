require_relative '../../automated_init'

context "Put" do
  context "No Stream" do
    context "Existing Stream" do
      stream_name = Controls::StreamName.example

      write_event_1 = Controls::EventData::Write.example
      write_event_2 = Controls::EventData::Write.example

      Put.(write_event_1, stream_name)

      erroneous = proc { Put.(write_event_2, stream_name, expected_version: NoStream.name) }

      test "Is an error" do
        assert erroneous do
          raises_error? ExpectedVersion::Error
        end
      end
    end
  end
end
