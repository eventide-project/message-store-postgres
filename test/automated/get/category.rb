require_relative '../automated_init'

context "Get" do
  context "Category" do
    category = Controls::Category.example

    stream_name, _ = Controls::Put.(instances: 2, category: category)

    messages = Get.(stream_name)

    number_of_messages = messages.length

    test "Number of messages retrieved is the number written to the category" do
      assert(number_of_messages == 2)
    end
  end
end
