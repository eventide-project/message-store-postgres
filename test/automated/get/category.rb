require_relative '../automated_init'

context "Get" do
  context "Category" do
    category = Controls::Category.example

    stream_name = Controls::Put.(instances: 2, category: category)

    events = Get.(stream_name)

    number_of_events = events.length

    test "Number of events retrieved is the number written to the category" do
      assert(number_of_events == 2)
    end
  end
end
