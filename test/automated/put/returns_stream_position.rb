require_relative '../automated_init'

context "Write Event Data" do
  stream_name = Controls::StreamName.example

  write_event = Controls::EventData::Write.example

  position = Put.(write_event, stream_name)

  test "Result is stream version" do
    refute(position.nil?)
  end
end
