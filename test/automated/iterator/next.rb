require_relative '../automated_init'

context "Iterator" do
  context "Next" do
    stream = Controls::Put.(instances: 2)

    get = Get.build(stream, batch_size: 1)

    iterator = Iterator.build(get)

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
