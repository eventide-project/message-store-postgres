require_relative '../../../automated_init'

context "Get" do
  context "Category" do
    context "Batch Size" do
      category = Controls::Category.example

      Controls::Put.(category: category)
      Controls::Put.(category: category)
      Controls::Put.(category: category)

      messages = Get::Category.(category, batch_size: 2)

      number_of_messages = messages.length

      test "Number of messages retrieved is the specified batch size" do
        assert(number_of_messages == 2)
      end
    end
  end
end
