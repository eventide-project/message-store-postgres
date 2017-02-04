require_relative '../../automated_init'

context "Iterator" do
  context "Next" do
    stream_name = Controls::Put.(instances: 2)

    iterator = Read::Iterator.build(stream_name)
    Get.configure(iterator, batch_size: 1)

    batch = []

    2.times do
      event_data = iterator.next
      batch << event_data unless event_data.nil?
    end

    test "Gets each event" do
      assert(batch.length == 2)
    end
  end
end
