require_relative '../automated_init'

Controls = EventSource::Postgres::Controls

context "Get" do
  context "No Events" do
    stream_name = Controls::StreamName.example

    batch = Get.(stream_name: stream_name)

    test "Empty array" do
      assert(batch == [])
    end
  end
end
