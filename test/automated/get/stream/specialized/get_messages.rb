require_relative '../../../automated_init'

context "Get" do
  context "Stream" do
    context "Specialized" do
      context "Get Message" do
        write_message = Controls::MessageData::Write.example

        category = Controls::Category.example

        stream_name, _ = Controls::Put.(category: category)
        Controls::Put.(category: category)

        message_data = Get::Stream.(stream_name)

        context "Messages Retrieved" do
          test "Only messages from the specific stream" do
            assert(message_data.length == 1)
          end

          context "Message stream is the stream written" do
            message_data.each do |md|
              message_stream_name = md.stream_name

              test do
                assert(message_stream_name == stream_name)
              end
            end
          end
        end
      end
    end
  end
end
