require_relative '../../automated_init'

context "Write" do
  context "Batch" do
    stream_name = Controls::StreamName.example

    write_event_1 = Controls::EventData::Write.example
    write_event_2 = Controls::EventData::Write.example

    batch = [write_event_1, write_event_2]

    last_written_position = Write.(batch, stream_name)

    test "Last written position" do
      assert(last_written_position == 1)
    end

    context "Individual Events are Written" do
      2.times do |i|
        read_event = Get.(stream_name, position: i, batch_size: 1).first
        write_event = batch[i]

        test "Event #{i + 1}" do
          assert(read_event.data == write_event.data)
        end
      end
    end
  end
end
