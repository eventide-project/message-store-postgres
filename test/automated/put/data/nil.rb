require_relative '../../automated_init'

context "Put" do
  context "Data" do
    context "Nil" do
      stream_name = Controls::StreamName.example
      write_event = Controls::EventData::Write.example(data: :none)

      position = Put.(write_event, stream_name)

      read_event = Get.(stream_name, position: position).first

      context "Read metadata" do
        test "Is nil" do
          assert(read_event.data.nil?)
        end
      end
    end
  end
end
