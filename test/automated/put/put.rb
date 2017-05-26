require_relative '../automated_init'

context "Put and Get" do
  stream_name = Controls::StreamName.example
  write_message = Controls::MessageData::Write.example

  position = Put.(write_message, stream_name)

  read_message = Get.(stream_name, position: position).first

  context "Got the message that was written" do
    test "ID" do
      assert(read_message.id == write_message.id)
    end

    test "Type" do
      assert(read_message.type == write_message.type)
    end

    test "Data" do
      assert(read_message.data == write_message.data)
    end

    test "Metadata" do
      assert(read_message.metadata == write_message.metadata)
    end

    test "Stream Name" do
      assert(read_message.stream_name == stream_name)
    end

    test "Position" do
      assert(read_message.position == position)
    end

    test "Global Position" do
      assert(read_message.global_position.is_a? Numeric)
    end

    test "Recorded Time" do
      assert(read_message.time.is_a? Time)
    end
  end
end
