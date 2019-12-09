require_relative '../../../automated_init'

context "Get" do
  context "Category" do
    context "Specialized" do
      context "Stream Name Error" do
        context "Retrieving from a Stream Using Stream Name" do
          stream_name = Controls::StreamName.example

          test "Is an error" do
            assert_raises(Get::Category::Error) do
              Get::Category.(stream_name)
            end
          end
        end
      end
    end
  end
end
