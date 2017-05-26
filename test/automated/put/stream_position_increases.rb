require_relative '../automated_init'

context "Put" do
  context "Stream Position Increases with Subsequent Writes" do
    stream_name = Controls::StreamName.example
    write_message = Controls::MessageData::Write.example

    position_1 = Put.(write_message, stream_name)
    position_2 = Put.(write_message, stream_name)

    test "First version is one less than the second version" do
      assert(position_1 + 1 == position_2)
    end
  end
end
