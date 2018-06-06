require_relative '../automated_init'

context "Get" do
  context "Batch Size" do
    stream_name, _ = Controls::Put.(instances: 3)

    messages = Get.(stream_name, batch_size: 2)

    number_of_messages = messages.length

    test "Number of messages retrieved is the specified batch size" do
      assert(number_of_messages == 2)
    end
  end
end
