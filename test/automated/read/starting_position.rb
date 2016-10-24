require_relative '../automated_init'

context "Read" do
  context "Starting Position" do
    stream = Controls::Put.(instances: 2)

    batch = []

    Read.(stream.name, position: 1, batch_size: 1) do |event_data|
      batch << event_data
    end

    test "Reads from the starting position" do
      assert(batch.length == 1)
    end
  end
end
