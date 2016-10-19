require_relative '../automated_init'

context "Put" do
  context "Category as Stream Name" do
    category = Controls::Category.example
    write_event = Controls::EventData::Write.example

    Put.(category, write_event)

    stream = Stream.new(category)

    read_event = Get.(stream).first

    test "Got the event that was written" do
      assert(read_event.stream_name == category)
    end
  end
end
