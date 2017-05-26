require_relative '../automated_init'

context "Put" do
  context "Missing ID" do
    stream_name = Controls::StreamName.example
    write_message = Controls::MessageData::Write.example(id: :none)

    position = Put.(write_message, stream_name)

    read_message = Get.(stream_name, position: position).first

    context "An ID is assigned to the message" do
      test "Write message" do
        refute(write_message.id.nil?)
      end

      test "Read message" do
        refute(read_message.id.nil?)
      end
    end
  end
end
