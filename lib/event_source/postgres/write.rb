module EventSource
  module Postgres
    class Write
      include EventSource::Write

      dependency :put

      def configure(session: nil)
        Put.configure(self, session: session)
      end

      def write(batch, stream_name, expected_version: nil)
        logger.trace { "Writing batch (Stream Name: #{stream_name}, Number of Events: #{batch.length}, Expected Version: #{expected_version.inspect})" }

        unless expected_version.nil?
          expected_version = ExpectedVersion.canonize(expected_version)
        end

        last_position = nil
        put.session.transaction do
          batch.each do |event_data|
            last_position = write_event(event_data, stream_name, expected_version: expected_version)

            unless expected_version.nil?
              expected_version += 1
            end
          end
        end

        logger.debug { "Wrote batch (Stream Name: #{stream_name}, Number of Events: #{batch.length}, Expected Version: #{expected_version.inspect})" }

        last_position
      end

      def write_event_data(event_data, stream_name, expected_version: nil)
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
