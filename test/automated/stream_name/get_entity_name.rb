require_relative '../automated_init'

context "Stream Name" do
  context "Get Entity Name" do
    category = 'someStream'

    context "Stream Name Contains an ID" do
      id = Identifier::UUID.random
      stream_name = "#{category}-#{id}"

      entity_name = StreamName.get_entity_name(stream_name)

      test "Entity name is the part of the stream name before the first dash" do
        assert(entity_name == category)
      end
    end

    context "Stream Name Contains no ID" do
      stream_name = category
      entity_name = StreamName.get_entity_name(stream_name)

      test "Entity name is the stream name" do
        assert(entity_name == category)
      end
    end

    context "Stream Name Contains Type" do
      stream_name = "#{category}:someType"
      entity_name = StreamName.get_entity_name(stream_name)

      test "Entity name is the category without any types" do
        assert(entity_name == category)
      end
    end

    context "Stream Name Contains Types" do
      stream_name = "#{category}:someType+someOtherType"
      entity_name = StreamName.get_entity_name(stream_name)

      test "Entity name is the category without any types" do
        assert(entity_name == category)
      end
    end

    context "Stream Name Contains ID and Types" do
      id = Identifier::UUID.random
      stream_name = "#{category}:someType+someOtherType-#{id}"
      entity_name = StreamName.get_entity_name(stream_name)

      test "Entity name is the category without any types" do
        assert(entity_name == category)
      end
    end
  end
end
