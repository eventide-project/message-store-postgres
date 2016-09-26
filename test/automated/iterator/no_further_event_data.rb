require_relative '../automated_init'

controls = EventSource::Postgres::Controls

context "Iterator" do
  context "No further event data" do
    stream_name = controls::Put.(instances: 2)

    iterator = Iterator.build(stream_name: stream_name)

    2.times { iterator.next }

    last = iterator.next

    test "Results in nil" do
      assert(last.nil?)
    end
  end
end
