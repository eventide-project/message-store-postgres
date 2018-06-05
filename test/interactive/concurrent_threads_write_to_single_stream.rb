require_relative './interactive_init'

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
    message_data = ::Controls::MessageData::Write.example

    MessageStore::Postgres::Write.(message_data, stream_name)

    logger.info { "Wrote message (Object ID: #{object_id}, Type: #{message_data.type.inspect}, Stream Name: #{stream_name.inspect})" }

    :write_message
  end
end

stream_name = Controls::StreamName.example

Actor::Supervisor.start do
  2.times do
    ExampleProcess.start(stream_name)
  end
end
