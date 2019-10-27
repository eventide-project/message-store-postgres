require_relative '../../automated_init'

context "Get" do
  context "Category" do
    context "No Messages" do
      category = Controls::Category.example

      batch = Get.(category)

      test "Retrieves no messages" do
        assert(batch == [])
      end
    end
  end
end
