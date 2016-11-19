require_relative '../automated_init'

context "Put and Get" do
  stream_name = Controls::StreamName.example(category: 'testPut')
  write_event = Controls::EventData::Write.example

  position = Put.(write_event, stream_name)

  read_event = Get.(stream_name, position: position).first

  context "Got the event that was written" do
    test "Type" do
      assert(read_event.type == write_event.type)
    end

    test "Data" do
      assert(read_event.data == write_event.data)
    end

    test "Metadata" do
      assert(read_event.metadata == write_event.metadata)
    end

    test "Stream Name" do
      assert(read_event.stream_name == stream_name)
    end

    test "Position" do
      assert(read_event.position == position)
    end

    test "Global Position" do
      assert(read_event.global_position.is_a? Numeric)
    end

    test "Recorded Time" do
      assert(read_event.time.is_a? Time)
    end
  end
end
