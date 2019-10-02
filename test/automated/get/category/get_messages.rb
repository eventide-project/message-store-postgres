require_relative '../../automated_init'

context "Get" do
  context "Category" do
    context "Get Messages" do
      category = Controls::Category.example

      Controls::Put.(category: category)
      Controls::Put.(category: category)

      messages = Get.(category)

      context "Messages Retrieved" do
        test "Messages from the all streams in the category" do
          assert(messages.length == 2)
        end
      end
    end
  end
end
