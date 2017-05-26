require_relative '../automated_init'

context "Read" do
  stream_name = Controls::Put.(instances: 2)

  batch = []

  Read.(stream_name, batch_size: 1) do |message_data|
    batch << message_data
  end

  test "Reads batches of messages" do
    assert(batch.length == 2)
  end
end
