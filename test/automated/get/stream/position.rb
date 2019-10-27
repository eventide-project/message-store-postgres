require_relative '../../automated_init'

context "Get" do
  context "Stream" do
    context "Position" do
      stream_name, _ = Controls::Put.(instances: 2)

      batch = Get.(stream_name, position: 1, batch_size: 1)

      test "Retrieves messages from the starting position" do
        assert(batch.length == 1)
      end
    end
  end
end
