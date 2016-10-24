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

      def configure(partition: nil, session: nil)
        Put.configure(self, partition: partition, session: session)
      end

      def self.call(subject, stream_name, expected_version: nil, partition: nil, session: nil)
        instance = build(partition: partition, session: session)
        instance.(subject, stream_name, expected_version: expected_version)
      end

      def call(subject, stream_name, expected_version: nil)
        logger.trace "Writing #{subject.class.subject} (Stream Name: #{stream_name}, Type: #{subject.type}, Expected Version: #{expected_version.inspect})"
        logger.trace subject.inspect, tags: [:data, :event_data]

        write_event_data = transform(subject)

        position = put.(write_event_data, stream_name, expected_version: expected_version)

        logger.debug "Wrote #{subject.class.subject} (Stream Name: #{stream_name}, Type: #{subject.type}, Expected Version: #{expected_version.inspect})"
        logger.debug write_event_data.inspect

        return position
      end

      def transform(subject)
        if subject.is_a? EventData
          return subject
        end

        logger.trace "Converting #{subject.class.message_type} to event data", tag: :transform
        logger.trace subject.inspect, tags: [:transform, :data, :message]

        ## TODO
        # run conversion on message
        write_event_data = subject

        logger.debug "Converted #{subject.class.message_type} to event data", tag: :transform
        logger.debug write_event_data.inspect, tags: [:transform, :data, :event_data]

        subject
      end
    end
  end
end
