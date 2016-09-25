require_relative '../automated_init'

controls = EventStream::Postgres::Controls

context "Write Event Data" do
  stream_name = controls::StreamName.example

  write_event = controls::EventData::Write.example

  stream_position = Put.(stream_name, write_event)

  test "Result is stream version" do
    refute(stream_position.nil?)
  end
end
