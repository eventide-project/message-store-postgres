require_relative '../automated_init'

context "Stream Name" do
  context "Is Category" do
    category = 'someStream'

    context "Stream Name Contains a Dash (-)" do
      id = Identifier::UUID.random
      stream_name = "#{category}-#{id}"

      is_category = StreamName.category?(stream_name)

      test "Not a category" do
        refute(is_category)
      end
    end

    context "Stream Name Contains no Dash (-)" do
      is_category = StreamName.category?(category)

      test "Is a category" do
        assert(is_category)
      end
    end
  end
end
