require_relative 'concurrency_init'

require 'actor'

class ExampleProcess
  include Actor
  include Log::Dependency

  attr_reader :stream_name

  def initialize(stream_name)
    @stream_name = stream_name
  end

  handle :start do
    :write_message
  end

  handle :write_message do
    message_data_1 = MessageStore::Postgres::Controls::MessageData::Write.example(data: { actor: object_id })
    message_data_2 = MessageStore::Postgres::Controls::MessageData::Write.example(data: { actor: object_id })
    batch = [message_data_1, message_data_2]

    position = MessageStore::Postgres::Write.(batch, stream_name)

    logger.info(tag: :actor) { "Wrote message data (Object ID: #{object_id}, Position: #{position}, Message Type: #{message_data_1.type.inspect}, Stream Name: #{stream_name.inspect})" }

    :write_message
  end
end

random = SecureRandom.hex[0..5]
stream_name = Controls::StreamName.example(category: "testConcurrentWrite-#{random}", randomize_category: false)

number_of_actors = Test::Interactive::Concurrency::Defaults.actors

puts
puts "Concurrent Write (#{number_of_actors} actors)"
puts "- - -"
puts

Actor::Supervisor.start do
  number_of_actors.times do
    ExampleProcess.start(stream_name)
  end
end
