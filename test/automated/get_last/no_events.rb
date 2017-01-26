require_relative '../automated_init'

context "Get Last" do
  context "No Events" do
    stream_name = Controls::StreamName.example

    last_event = Get::Last.(stream_name)

    test "Nil event" do
      assert(last_event.nil?)
    end
  end
end
