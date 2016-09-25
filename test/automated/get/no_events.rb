require_relative '../automated_init'

controls = EventStream::Postgres::Controls

context "Get" do
  context "No Events" do
    stream_name = controls::StreamName.example

    batch = Get.(stream_name: stream_name)

    test "Empty array" do
      assert(batch == [])
    end
  end
end
