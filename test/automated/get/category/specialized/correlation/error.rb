require_relative '../../../../automated_init'

context "Get" do
  context "Category" do
    context "Specialized" do
      context "Correlation" do
        context "Not a Category" do
          correlation = Controls::StreamName.example

          category = Controls::Category.example

          test "Is an error" do
            assert_raises(MessageStore::Postgres::Correlation::Error) do
              Get::Category.(category, correlation: correlation)
            end
          end
        end
      end
    end
  end
end
