require_relative '../automated_init'

context "Category Stream Name" do
  test "Is the category name" do
    category_stream_name = StreamName.category_stream_name 'SomeCategory'
    assert(category_stream_name == 'SomeCategory')
  end
end
