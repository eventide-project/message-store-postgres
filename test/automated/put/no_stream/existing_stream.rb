require_relative '../../automated_init'

context "Put" do
  context "No Stream" do
    context "Existing Stream" do
      stream_name = Controls::StreamName.example(category: 'testPutNoStreamExistingStream')

      write_event_1 = Controls::EventData::Write.example(data: {:some_attribute => 'first'})
      write_event_2 = Controls::EventData::Write.example(data: {:some_attribute => 'second'})

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
