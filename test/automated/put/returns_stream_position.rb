require_relative '../automated_init'

context "Put" do
  context "Returns Stream Position" do
    stream_name = Controls::StreamName.example

    write_message = Controls::MessageData::Write.example

    position = Put.(write_message, stream_name)

    test "Result is stream position" do
      refute(position.nil?)
    end
  end
end
