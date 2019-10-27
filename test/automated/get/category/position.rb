require_relative '../../automated_init'

context "Get" do
  context "Category" do
    context "Position" do
      category = Controls::Category.example
      stream_name = Controls::StreamName.example(category: category)

      Controls::Put.(instances: 2, stream_name: stream_name)

      batch = Get.(category, position: 1, batch_size: 1)

      test "Retrieves messages from the starting position" do
        assert(batch.length == 1)
      end
    end
  end
end
