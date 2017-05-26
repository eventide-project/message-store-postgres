require_relative '../../automated_init'

context "Write" do
  context "Batch" do
    stream_name = Controls::StreamName.example

    write_message_1 = Controls::MessageData::Write.example
    write_message_2 = Controls::MessageData::Write.example

    batch = [write_message_1, write_message_2]

    last_written_position = Write.(batch, stream_name)

    test "Last written position" do
      assert(last_written_position == 1)
    end

    context "Individual Messages are Written" do
      2.times do |i|
        read_message = Get.(stream_name, position: i, batch_size: 1).first
        write_message = batch[i]

        test "Message #{i + 1}" do
          assert(read_message.data == write_message.data)
        end
      end
    end
  end
end
