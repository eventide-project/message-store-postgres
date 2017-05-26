require_relative '../automated_init'

context "Get" do
  context "No Messages" do
    stream_name = Controls::StreamName.example

    batch = Get.(stream_name)

    test "Empty array" do
      assert(batch == [])
    end
  end
end
