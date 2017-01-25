require_relative '../automated_init'

context "Put" do
  context "Missing ID" do
    stream_name = Controls::StreamName.example
    write_event = Controls::EventData::Write.example(id: :none)

    position = Put.(write_event, stream_name)

    read_event = Get.(stream_name, position: position).first

    context "An ID is assigned to the event" do
      test "Write event" do
        refute(write_event.id.nil?)
      end

      test "Read event" do
        refute(read_event.id.nil?)
      end
    end
  end
end
