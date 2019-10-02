require_relative '../../automated_init'

context "Get" do
  context "Stream" do
    context "Get Message" do
      write_message = Controls::MessageData::Write.example

      category = Controls::Category.example

      stream_name, _ = Controls::Put.(category: category)
      Controls::Put.(category: category)

      messages = Get.(stream_name)

      context "Messages Retrieved" do
        test "Only messages from the specific stream" do
          assert(messages.length == 1)
        end
      end
    end
  end
end
