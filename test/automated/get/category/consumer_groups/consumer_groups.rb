require_relative '../../../automated_init'

context "Get" do
  context "Category" do
    context "Consumer Groups" do
      category = Controls::Category.example

      instances = 11
      partitions = 3

      instances.times do
        Controls::Put.(category: category)
      end

      retrieved_count = 0
      partitions.times do |i|
        messages = Get.(category, consumer_group_member: i, consumer_group_size: partitions)
        retrieved_count += messages.count
      end

      test "Retrieve messages in partitions" do
        assert(retrieved_count == instances)
      end
    end
  end
end
