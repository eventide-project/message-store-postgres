require_relative '../automated_init'

context "Stream Name" do
  context "Get Category" do
    category = 'someStream'

    context "Stream Name Contains an ID" do
      id = Identifier::UUID.random
      stream_name = "#{category}-#{id}"

      stream_category = StreamName.get_category(stream_name)

      test "Category name is the part of the stream name before the first dash" do
        assert(stream_category == category)
      end
    end

    context "Stream Name Contains no ID" do
      stream_name = category
      stream_category = StreamName.get_category(stream_name)

      test "Category name is the stream name" do
        assert(stream_category == category)
      end
    end

    context "Stream Name Contains Type" do
      stream_name = "#{category}:someType"
      stream_category = StreamName.get_category(stream_name)

      test "Category name is the stream name" do
        assert(stream_category == stream_name)
      end
    end

    context "Stream Name Contains Types" do
      stream_name = "#{category}:someType+someOtherType"
      stream_category = StreamName.get_category(stream_name)

      test "Category name is the stream name" do
        assert(stream_category == stream_name)
      end
    end

    context "Stream Name Contains ID and Types" do
      id = Identifier::UUID.random
      category_and_types = "#{category}:someType+someOtherType"
      stream_name = "#{category_and_types}-#{id}"

      stream_category = StreamName.get_category(stream_name)

      test "Category name is the stream name" do
        assert(stream_category == category_and_types)
      end
    end
  end
end
