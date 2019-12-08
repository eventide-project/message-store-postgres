require_relative '../../../automated_init'

context "Get" do
  context "Stream" do
    context "Last" do
      context "Category" do
        category = Controls::Category.example

        Controls::Put.(instances: 2, stream_name: category)

        write_message = Controls::MessageData::Write.example

        Put.(write_message, category)

        last_message = Get::Stream::Last.(category)

        test "Gets the last message in the stream" do
          assert(last_message.data == write_message.data)
        end
      end
    end
  end
end
