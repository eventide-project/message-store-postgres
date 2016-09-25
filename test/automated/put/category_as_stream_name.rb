require_relative '../automated_init'

controls = EventStream::Postgres::Controls

context "Put" do
  context "Category as Stream Name" do
    category = controls::Category.example
    write_event = controls::EventData::Write.example

    Put.(category, write_event)

    read_event = Get.(stream_name: category).first

    test "Got the event that was written" do
      assert(read_event.stream_name == category)
    end
  end
end
