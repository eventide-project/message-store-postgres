require_relative '../../automated_init'

context "Iterator" do
  context "Category" do
    context "No Further Message Data" do
      stream_name, _ = Controls::Put.()

      category = StreamName.get_category(stream_name)

      Controls::Put.(category: category)

      iterator = Read::Iterator.build
      Get.configure(iterator, batch_size: 1)

      2.times { iterator.next }

      last = iterator.next

      test "Results in nil" do
        assert(last.nil?)
      end
    end
  end
end
