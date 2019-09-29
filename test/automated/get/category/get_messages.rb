require_relative '../../automated_init'

context "Get" do
  context "Category" do
    context "Get Messages" do
      write_message = Controls::MessageData::Write.example

      category = Controls::Category.example

      stream_name_1, _ = Controls::Put.(category: category)
      stream_name_2, _ = Controls::Put.(category: category)

      messages = Get.(category)

      context "Messages Retrieved" do
        test "Messages from the all streams in the category" do
          assert(messages.length == 2)
        end
      end
    end
  end
end
