require_relative '../../../automated_init'

context "Get" do
  context "Stream" do
    context "Last" do
      context "Not a Stream Name" do
        category = Controls::Category.example

        test "Is an error" do
          assert_raises(MessageStore::Postgres::Get::Stream::Last::Error) do
            Get::Stream::Last.(category)
          end
        end
      end
    end
  end
end
