module EventSource
  module Postgres
    class Write
      include Log::Dependency

      dependency :put, Put

      def self.build(partition: nil, session: nil)
        instance = new
        instance.configure(partition: partition, session: session)
        instance
      end

      def self.configure(receiver, partition: nil, session: nil, attr_name: nil)
        attr_name ||= :writer
        instance = build(partition: partition, session: session)
        receiver.public_send "#{attr_name}=", instance
      end

      def configure(partition: nil, session: nil)
        Put.configure(self, partition: partition, session: session)
      end

      def self.call(event_data, stream_name, expected_version: nil, partition: nil, session: nil)
        instance = build(partition: partition, session: session)
        instance.(event_data, stream_name, expected_version: expected_version)
      end

      def call(event_data, stream_name, expected_version: nil)
        logger.trace { "Writing event data (Stream Name: #{stream_name}, Expected Version: #{expected_version.inspect})" }
        logger.trace(tags: [:data, :event_data]) { event_data.pretty_inspect }

        batch = Array(event_data)
        position = write_batch(batch, stream_name, expected_version: expected_version)

        logger.debug { "Wrote event data (Stream Name: #{stream_name}, Expected Version: #{expected_version.inspect})" }
        logger.debug(tags: [:data, :event_data]) { event_data.pretty_inspect }

        position
      end

      def write_batch(batch, stream_name, expected_version: nil)
        logger.trace { "Writing batch (Stream Name: #{stream_name}, Number of Events: #{batch.length}, Expected Version: #{expected_version.inspect})" }

        last_position = nil
        put.session.connection.transaction do
          batch.each do |event_data|
            last_position = write(event_data, stream_name, expected_version: expected_version)
          end
        end

        logger.debug { "Wrote batch (Stream Name: #{stream_name}, Number of Events: #{batch.length}, Expected Version: #{expected_version.inspect})" }

        last_position
      end

      def write(event_data, stream_name, expected_version: nil)
        logger.trace { "Writing event data (Stream Name: #{stream_name}, Type: #{event_data.type}, Expected Version: #{expected_version.inspect})" }
        logger.trace(tags: [:data, :event_data]) { event_data.pretty_inspect }

        put.(event_data, stream_name, expected_version: expected_version).tap do
          logger.debug { "Wrote event data (Stream Name: #{stream_name}, Type: #{event_data.type}, Expected Version: #{expected_version.inspect})" }
          logger.debug(tags: [:data, :event_data]) { event_data.pretty_inspect }
        end
      end
    end
  end
end
