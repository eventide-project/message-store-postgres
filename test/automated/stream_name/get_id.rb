require_relative '../automated_init'

context "Stream Name" do
  context "Get ID" do
    test "Is the part of a stream name after the first dash" do
      id = Identifier::UUID.random
      stream_name = "someStream-#{id}"

      stream_id = StreamName.get_id(stream_name)

      assert(stream_id == id)
    end

    test "Is nil if there is no ID part in the stream name" do
      stream_id = StreamName.get_id('someStream')
      assert(stream_id.nil?)
    end
  end
end
