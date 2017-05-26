require_relative '../automated_init'

context "Get Last" do
  context "No Messages" do
    stream_name = Controls::StreamName.example

    last_message = Get::Last.(stream_name)

    test "Nil message" do
      assert(last_message.nil?)
    end
  end
end
