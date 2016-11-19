require_relative '../automated_init'

context "Put" do
  context "Returns Stream Position" do
    stream_name = Controls::StreamName.example(category: 'testPutReturnsStreamPosition')

    write_event = Controls::EventData::Write.example

    position = Put.(write_event, stream_name)

    test "Result is stream position" do
      refute(position.nil?)
    end
  end
end
