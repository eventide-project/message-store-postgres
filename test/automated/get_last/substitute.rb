require_relative '../automated_init'

context "Get Last" do
  context "Substitute" do
    stream_name = Controls::StreamName.example

    control_message_data = Controls::MessageData::Read.example

    context "Message Is Set" do
      substitute = SubstAttr::Substitute.build(Get::Stream::Last)

      substitute.set(stream_name, control_message_data)

      message_data = substitute.(stream_name)

      test "Returns the message that was set" do
        assert(message_data == control_message_data)
      end
    end

    context "Message Not Set" do
      substitute = SubstAttr::Substitute.build(Get::Stream::Last)

      message_data = substitute.(stream_name)

      test "Returns nil" do
        assert(message_data.nil?)
      end
    end
  end
end
