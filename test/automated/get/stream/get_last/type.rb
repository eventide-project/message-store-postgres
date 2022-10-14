require_relative '../../../automated_init'

context "Get" do
  context "Stream" do
    context "Last" do
      context "Type" do
        control_type = Controls::MessageData.type
        other_type = "SomeOtherType"

        stream_name, _ = Controls::Put.(instances: 2, type: control_type)

        write_message = Controls::MessageData::Write.example(type: control_type)

        Put.(write_message, stream_name)

        Controls::Put.(instances: 2, stream_name: stream_name, type: other_type)

        last_message = Get::Stream::Last.(stream_name, control_type)

        test "Gets the last message in the stream" do
          assert(last_message.data == write_message.data)
        end

        context "Type" do
          type = last_message.type

          comment "#{type}"
          detail "Control: #{control_type}"

          test do
            assert(type == control_type)
          end
        end
      end
    end
  end
end
