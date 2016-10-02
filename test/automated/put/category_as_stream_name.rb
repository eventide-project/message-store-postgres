require_relative '../automated_init'

context "Put" do
  context "Category as Stream Name" do
    category = Controls::Category.example
    write_event = Controls::EventData::Write.example

    Put.(category, write_event)

    read_event = Get.(stream_name: category).first

    test "Got the event that was written" do
      assert(read_event.stream_name == category)
    end
  end
end
