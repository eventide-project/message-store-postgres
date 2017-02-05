require_relative '../automated_init'

context "Stream Name" do
  context "Category" do
    stream_name = StreamName.stream_name('someCategory')

    test "Stream name is the category" do
      assert(stream_name == 'someCategory')
    end
  end

  context "Category and ID" do
    stream_name = StreamName.stream_name('someCategory', 'some_id')

    test "Stream name is the category and the ID" do
      assert(stream_name == 'someCategory-some_id')
    end
  end

  context "Category and Type" do
    stream_name = StreamName.stream_name('someCategory', type: 'someType')

    test "Stream name is the category and the Type" do
      assert(stream_name == 'someCategory:someType')
    end
  end

  context "Category and Types" do
    stream_name = StreamName.stream_name('someCategory', types: ['someType', 'someOtherType'])

    test "Stream name is the category and the types delimited by the plus (+) sign" do
      assert(stream_name == 'someCategory:someType+someOtherType')
    end
  end

  context "Category, Type, and Types" do
    stream_name = StreamName.stream_name('someCategory', type: 'someType', types: ['someOtherType', 'yetAnotherYet'])

    test "Stream name is the category and the types delimited by the plus (+) sign" do
      assert(stream_name == 'someCategory:someType+someOtherType+yetAnotherYet')
    end
  end

  context "Category, Type and ID" do
    stream_name = StreamName.stream_name('someCategory', 'some_id', type: 'someType')

    test "Stream name is the category, type and ID" do
      assert(stream_name == 'someCategory:someType-some_id')
    end
  end
end
