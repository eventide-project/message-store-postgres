require_relative '../bench_init'

context "Write Batch of Events" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get 'testEventWriter'
  path = "/streams/#{stream_name}"

  writer = EventStore::Client::HTTP::EventWriter.build

  id_1 = EventStore::Client::HTTP::Controls::ID.example 1
  id_2 = EventStore::Client::HTTP::Controls::ID.example 2

  event_data_1 = EventStore::Client::HTTP::Controls::EventData::Write.example(id_1)
  event_data_2 = EventStore::Client::HTTP::Controls::EventData::Write.example(id_2)

  event_data_1.data[:some_attribute] = id_1
  event_data_2.data[:some_attribute] = id_2

  writer.write [event_data_1, event_data_2], stream_name

  get = EventStore::Client::HTTP::Request::Get.build
  body_text_1, get_response = get.("#{path}/0")
  body_text_2, get_response = get.("#{path}/1")

  read_data_1 = Serialize::Read.(body_text_1, EventStore::Client::HTTP::EventData::Read, :json)
  read_data_2 = Serialize::Read.(body_text_2, EventStore::Client::HTTP::EventData::Read, :json)

  2.times do |i|
    i += 1
    event_data = binding.local_variable_get "read_data_#{i}"

    test "Individual events are written" do
      control_value = binding.local_variable_get "id_#{i}"

      assert event_data.data[:some_attribute] == control_value
    end
  end
end
