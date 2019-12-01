require_relative '../../../../automated_init'

context "Get" do
  context "Category" do
    context "Specialized" do
      context "Consumer Groups" do
        category = Controls::Category.example

        instances = 11
        partitions = 3

        instances.times do
          Controls::Put.(category: category)
        end

        retrieved_message_data = []
        partitions.times do |i|
          retrieved_message_data += Get::Category.(category, consumer_group_member: i, consumer_group_size: partitions)
        end

        context "Message Partitions" do
          context "Distribution" do
            retrieved_count = retrieved_message_data.count

            test "Across partitions" do
              assert(retrieved_count == instances)
            end
          end
        end

        context "Messages in all partitions" do
          test "Are of the same category" do
            retrieved_message_data.each do |message_data|
              assert(StreamName.get_category(message_data.stream_name) == category)
            end
          end
        end
      end
    end
  end
end
