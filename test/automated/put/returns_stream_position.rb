require_relative '../automated_init'

Controls = EventSource::Postgres::Controls

context "Write Event Data" do
  stream_name = Controls::StreamName.example

  write_event = Controls::EventData::Write.example

  stream_position = Put.(stream_name, write_event)

  test "Result is stream version" do
    refute(stream_position.nil?)
  end
end
