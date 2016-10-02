require_relative '../../automated_init'

Controls = EventSource::Postgres::Controls

context "Put" do
  context "No Stream" do
    context "Existing Stream" do
      stream_name = Controls::StreamName.example

      write_event_1 = Controls::EventData::Write.example(data: {:some_attribute => 'first'})
      write_event_2 = Controls::EventData::Write.example(data: {:some_attribute => 'second'})

      Put.(stream_name, write_event_1)

      erroneous = proc { Put.(stream_name, write_event_2, expected_version: NoStream.name) }

      test "Is an error" do
        assert erroneous do
          raises_error? Write::ExpectedVersionError
        end
      end
    end
  end
end
