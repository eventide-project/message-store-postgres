require_relative '../../../automated_init'

context "Write" do
  context "Batch" do
    context "Expected Version" do
      stream_name = Controls::StreamName.example

      write_message = Controls::MessageData::Write.example
      position = Write.(write_message, stream_name)

      write_message_1 = Controls::MessageData::Write.example
      write_message_2 = Controls::MessageData::Write.example

      batch = [write_message_1, write_message_2]

      Write.(batch, stream_name, expected_version: position)

      context "Individual Messages are Written" do
        2.times do |i|
          read_message = Get.(stream_name, position: i + 1, batch_size: 1).first
          write_message = batch[i]

          test "Message #{i + 1}" do
            assert(read_message.data == write_message.data)
          end
        end
      end
    end
  end
end
