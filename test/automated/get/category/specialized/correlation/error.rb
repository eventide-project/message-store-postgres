require_relative '../../../../automated_init'

context "Get" do
  context "Category" do
    context "Correlation" do
      context "Not a Category" do
        correlation = Controls::StreamName.example

        category = Controls::Category.example

        test "Is an error" do
          assert_raises(MessageStore::Correlation::Error) do
            Get::Category.(category, correlation: correlation)
          end
        end
      end
    end
  end
end
