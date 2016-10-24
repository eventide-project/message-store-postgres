module EventSource
  module Postgres
    class Put
      include Log::Dependency

      dependency :session, Session

      def partition
        @partition ||= Defaults.partition
      end
      attr_writer :partition

      initializer :stream_name

      def self.build(stream_name, partition: nil, session: nil)
        new(stream_name).tap do |instance|
          instance.partition = partition
          instance.configure(session: session)
        end
      end

      def configure(session: nil)
        Session.configure(self, session: session)
      end

      ## TODO
      # def self.configure

      def self.call(stream_name, write_event, expected_version: nil, partition: nil, session: nil)
        instance = build(stream_name, partition: partition, session: session)
        instance.(write_event, expected_version: expected_version)
      end

      def call(write_event, expected_version: nil)
        logger.trace "Putting event data (Stream Name: #{stream_name}, Type: #{write_event.type}, Expected Version: #{expected_version.inspect})"
        logger.trace write_event.inspect, tags: [:data, :event_data]

        type, data, metadata = destructure_event(write_event)
        expected_version = canonize_expected_version(expected_version)

        position = insert_event(type, data, metadata, expected_version)

        logger.debug "Put event data (Stream Name: #{stream_name}, Type: #{write_event.type}, Expected Version: #{expected_version.inspect})"

        position
      end

      def destructure_event(write_event)
        type = write_event.type
        data = write_event.data
        metadata = write_event.metadata

        logger.debug "Data: #{data.inspect}",  tags: [:data, :event_data]
        logger.debug "Metadata: #{metadata.inspect}", tags: [:data, :event_data]

        return type, data, metadata
      end

      def canonize_expected_version(expected_version)
        return expected_version unless expected_version == NoStream.name

        logger.trace "Canonizing expected version (Expected Version: #{expected_version})"
        expected_version = NoStream.version
        logger.debug "Canonized expected version (Expected Version: #{expected_version})"
        expected_version
      end

      def insert_event(type, data, metadata, expected_version)
        serialized_data = serialized_data(data)
        serialized_metadata = serialized_metadata(metadata)
        records = execute_query(type, serialized_data, serialized_metadata, expected_version)
        position(records)
      end

      def execute_query(type, serialized_data, serialized_metadata, expected_version)
        logger.trace "Executing insert (Stream Name: #{stream_name}, Type: #{type}, Expected Version: #{expected_version.inspect})"

        sql_args = [
          stream_name,
          type,
          serialized_data,
          partition,
          serialized_metadata,
          expected_version
        ]

        begin
          records = session.connection.exec_params(statement, sql_args)
        rescue PG::RaiseException => e
          raise_error e
        end

        logger.debug "Executed insert (Stream Name: #{stream_name}, Type: #{type}, Expected Version: #{expected_version.inspect})"

        records
      end

      def statement
        "SELECT write_event($1::varchar, $2::varchar, $3::jsonb, $4::varchar, $5::jsonb, $6::int);"
      end

      def serialized_data(data)
        serializable_data = EventData::Hash[data]
        serialized_data = Serialize::Write.(serializable_data, :json)
        logger.debug "Serialized Data: #{serialized_data.inspect}", tags: [:data, :serialize]
        serialized_data
      end

      def serialized_metadata(metadata)
        serializable_metadata = EventData::Hash[metadata]
        serialized_metadata = nil
        unless metadata.nil?
          serialized_metadata = Serialize::Write.(serializable_metadata, :json)
        end
        logger.debug "Serialized Metadata: #{serialized_metadata.inspect}", tags: [:data, :serialize]
        serialized_metadata
      end

      def position(records)
        position = nil
        unless records[0].nil?
          position = records[0].values[0]
        end
        position
      end

      def raise_error(pg_error)
        error_message = pg_error.message
        if error_message.include? 'Wrong expected version'
          error_message.gsub!('ERROR:', '').strip!
          raise ExpectedVersionError, error_message
        end
        raise pg_error
      end

      module Defaults
        def self.partition
          Partition::Defaults.name
        end
      end
    end
  end
end
