require_relative '../automated_init'

context "Read" do
  partition = Controls::Partition.example

  stream_name = Controls::Put.(instances: 2, partition: partition)

  batch = []

  Read.(stream_name, partition: partition, batch_size: 1) do |event_data|
    batch << event_data
  end

  test "Reads batches of events" do
    assert(batch.length == 2)
  end
end
