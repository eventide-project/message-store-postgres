require_relative '../../automated_init'

context "Put" do
  context "Data" do
    context "Nil" do
      stream_name = Controls::StreamName.example
      write_message = Controls::MessageData::Write.example(data: :none)

      position = Put.(write_message, stream_name)

      read_message = Get.(stream_name, position: position).first

      context "Read metadata" do
        test "Is nil" do
          assert(read_message.data.nil?)
        end
      end
    end
  end
end
