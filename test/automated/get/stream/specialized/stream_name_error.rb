require_relative '../../../automated_init'

context "Get" do
  context "Stream" do
    context "Specialized" do
      context "Stream Name Error" do
        context "Retrieving from a Stream Using Category Name" do
          category = Controls::Category.example

          test "Is an error" do
            assert_raises(Get::Stream::Error) do
              Get::Stream.(category)
            end
          end
        end
      end
    end
  end
end
