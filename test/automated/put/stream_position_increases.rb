require_relative '../automated_init'

context "Stream Version Increases with Subsequent Writes" do
  stream_name = Controls::StreamName.example
  write_event = Controls::EventData::Write.example

  position_1 = Put.(stream_name, write_event)
  position_2 = Put.(stream_name, write_event)

  test "First version is one less than the second version" do
    assert(position_1 + 1 == position_2)
  end
end
