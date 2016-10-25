require_relative '../bench_init'

context "Writer Telemetry" do
  context "Write" do
    message = EventStore::Messaging::Controls::Message.example
    writer = EventStore::Messaging::Writer.build

    SubstAttr::Substitute.(:writer, writer)

    stream_name = EventStore::Messaging::Controls::StreamName.get 'testWriter'

    sink = EventStore::Messaging::Writer.register_telemetry_sink(writer)

    writer.write message, stream_name, expected_version: 11, reply_stream_name: 'some_stream_name'

    test "Records written telemetry" do
      assert(sink.recorded_written?)
    end

    context "Recorded Data" do
      data = sink.records[0].data

      test "message" do
        assert(data.message == message)
      end

      test "stream_name" do
        assert(data.stream_name == stream_name)
      end

      test "expected_version" do
        assert(data.expected_version == 11)
      end

      test "reply_stream_name" do
        assert(data.reply_stream_name == 'some_stream_name')
      end
    end
  end

  context "Reply" do
    message = EventStore::Messaging::Controls::Message.example
    writer = EventStore::Messaging::Writer.build

    SubstAttr::Substitute.(:writer, writer)

    sink = EventStore::Messaging::Writer.register_telemetry_sink(writer)

    writer.reply message

    test "Records replied telemetry" do
      assert(sink.recorded_replied?)
    end
  end
end
