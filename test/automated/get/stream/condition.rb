require_relative '../../automated_init'

context "Get" do
  context "Stream" do
    context "Condition" do
      stream_name, _ = Controls::Put.(instances: 3)

      condition = 'position = 0 OR position = 2'

      messages = Get.(stream_name, batch_size: 3, condition: condition)

      message_positions = messages.map do |message|
        message.position
      end

      test "Returns messages that meet the condition" do
        assert(message_positions == [0, 2])
      end
    end
  end
end
