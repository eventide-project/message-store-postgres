module EventSource
  module Postgres
    class Write
      include EventSource::Write

      dependency :put

      def configure(session: nil)
        Put.configure(self, session: session)
      end

      def write(batch, stream_name, expected_version: nil)
        logger.trace(tag: :write) { "Writing batch (Stream Name: #{stream_name}, Number of Messages: #{batch.length}, Expected Version: #{expected_version.inspect})" }

        unless expected_version.nil?
          expected_version = ExpectedVersion.canonize(expected_version)
        end

        last_position = nil
        put.session.transaction do
          batch.each do |message_data|
            last_position = write_message_data(message_data, stream_name, expected_version: expected_version)

            unless expected_version.nil?
              expected_version += 1
            end
          end
        end

        logger.debug(tag: :write) { "Wrote batch (Stream Name: #{stream_name}, Number of Messages: #{batch.length}, Expected Version: #{expected_version.inspect})" }

        last_position
      end

      def write_message_data(message_data, stream_name, expected_version: nil)
        logger.trace(tag: :write) { "Writing message data (Stream Name: #{stream_name}, Type: #{message_data.type}, Expected Version: #{expected_version.inspect})" }
        logger.trace(tags: [:data, :message_data, :write]) { message_data.pretty_inspect }

        put.(message_data, stream_name, expected_version: expected_version).tap do
          logger.debug(tag: :write) { "Wrote message data (Stream Name: #{stream_name}, Type: #{message_data.type}, Expected Version: #{expected_version.inspect})" }
          logger.debug(tags: [:data, :message_data, :write]) { message_data.pretty_inspect }
        end
      end
    end
  end
end
