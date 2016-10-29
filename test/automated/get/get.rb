require_relative '../automated_init'

context "Put and Get" do
  stream = Controls::Stream.example
  write_event = Controls::EventData::Write.example

  written_position = Put.(write_event, stream.name)

  read_event = Get.(stream, position: written_position).first

  context "Got the event that was written" do
    test "Data" do
      # assert(read_event.data == Controls::EventData::Write.data)
    end

    test "Position" do
      assert(read_event.position == written_position)
    end
  end
end

__END__

@created_time=2016-10-29 03:10:44 UTC,
 @data={:some_attribute=>"some value"},
 @global_position=1332,
 @metadata={:some_meta_attribute=>"some meta value"},
 @position=0,
 @stream_name=
  "test3e44aba36b15ba24330689a33e403711XX-8236f048-7c04-46de-92b2-ed0fbf7a8a06",
 @type="SomeType">
