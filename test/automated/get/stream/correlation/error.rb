require_relative '../../../automated_init'

context "Get" do
  context "Stream" do
    context "Correlation" do
      context "Not a Category" do
        correlation = Controls::StreamName.example

        stream_name = Controls::StreamName.example

        test "Is an error" do
          assert_raises MessageStore::Correlation::Error do
            Get.(stream_name, correlation: correlation)
          end
        end
      end
    end
  end
end
