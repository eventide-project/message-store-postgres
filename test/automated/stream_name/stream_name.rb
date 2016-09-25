require_relative '../automated_init'

context "Stream Name" do
  stream_name = StreamName.stream_name 'someCategory', 'some_id'

  test "Composes the stream name from the category name and an ID" do
    assert(stream_name == 'someCategory-some_id')
  end
end
