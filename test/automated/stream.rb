require_relative 'automated_init'

controls = EventStream::Postgres::Controls

context "Stream" do
  context "Stream Name" do
    category = 'some_stream'
    stream_name = controls::StreamName.example category: category
    stream = Stream.build stream_name: stream_name

    test "Name" do
      assert(stream.name == stream_name)
    end

    test "Type" do
      assert(stream.type == :stream)
    end

    test "Stream Name" do
      assert(stream.stream_name == stream_name)
    end

    test "Category" do
      assert(stream.category == category)
    end
  end

  context "Category" do
    category = 'some_stream'

    stream = Stream.build category: category

    test "Name" do
      assert(stream.name == category)
    end

    test "Type" do
      assert(stream.type == :category)
    end

    test "Stream Name" do
      assert(stream.stream_name == category)
    end

    test "Category" do
      assert(stream.category == category)
    end
  end

  context "Neither Stream Name or Category" do
    test "Is an error" do
      assert proc { Stream.build } do
        raises_error? Stream::NameError
      end
    end
  end

  context "Both Stream Name and Category" do
    test "Is an error" do
      assert proc { Stream.build stream_name: 'some_stream', category: 'some_category' } do
        raises_error? Stream::NameError
      end
    end
  end
end
