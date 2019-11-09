require_relative '../../../automated_init'

context "Get" do
  context "Stream" do
    context "Last" do
      context "No Messages" do
        stream_name = Controls::StreamName.example

        last_message = Get::Stream::Last.(stream_name)

        test "Nil message" do
          assert(last_message.nil?)
        end
      end
    end
  end
end
