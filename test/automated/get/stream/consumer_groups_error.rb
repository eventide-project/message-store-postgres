require_relative '../../automated_init'

context "Get" do
  context "Stream" do
    context "Consumer Groups" do
      context "Retrieving from a Stream Using Consumer Groups" do
        stream_name = Controls::StreamName.example

        test "Is an error" do
          assert_raises(Get::Error) do
            Get.(stream_name, consumer_group_member: 0, consumer_group_size: 1)
          end
        end
      end
    end
  end
end
