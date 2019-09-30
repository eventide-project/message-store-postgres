require_relative '../../automated_init'

context "Iterator" do
  context "Category" do
    context "Next" do
      stream_name, _ = Controls::Put.()

      category = StreamName.get_category(stream_name)

      Controls::Put.(category: category)

      iterator = Read::Iterator.build
      Get.configure(iterator, category, batch_size: 1)

      batch = []

      2.times do
        message_data = iterator.next
        batch << message_data unless message_data.nil?
      end

      test "Gets each message" do
        assert(batch.length == 2)
      end
    end
  end
end
