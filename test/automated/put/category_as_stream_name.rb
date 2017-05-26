require_relative '../automated_init'

context "Put" do
  context "Category as Stream Name" do
    category = Controls::Category.example
    write_message = Controls::MessageData::Write.example

    Put.(write_message, category)

    read_message = Get.(category).first

    test "Writes the category name as the stream name" do
      assert(read_message.stream_name == category)
    end
  end
end
