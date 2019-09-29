require_relative '../../automated_init'

context "Get" do
  context "Stream" do
    context "Get Message" do
      write_message = Controls::MessageData::Write.example

      category = Controls::Category.example

      stream_name_1, _ = Controls::Put.(category: category)
      stream_name_2, _ = Controls::Put.(category: category)

      messages = Get.(stream_name_1)

      context "Messages Retrieved" do
        test "Only messages from the specific stream" do
          assert(messages.length == 1)
        end
      end
    end
  end
end
