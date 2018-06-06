require_relative '../automated_init'

context "Read" do
  context "Position" do
    stream_name, _ = Controls::Put.(instances: 2)

    batch = []

    Read.(stream_name, position: 1, batch_size: 1) do |message_data|
      batch << message_data
    end

    test "Reads from the starting position" do
      assert(batch.length == 1)
    end
  end
end
