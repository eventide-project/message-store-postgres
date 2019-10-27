require_relative '../../automated_init'

context "Get" do
  context "Stream" do
    context "No Messages" do
      stream_name = Controls::StreamName.example

      batch = Get.(stream_name)

      test "Retrieves no messages" do
        assert(batch == [])
      end
    end
  end
end
