module EventSource
  module Postgres
    class Put
      include Log::Dependency

      dependency :session, Session
      dependency :identifier, Session

      def self.build(session: nil)
        new.tap do |instance|
          instance.configure(session: session)
        end
      end

      def configure(session: nil)
        Session.configure(self, session: session)
        Identifier::UUID::Random.configure(self)
      end

      def self.configure(receiver, session: nil, attr_name: nil)
        attr_name ||= :put
        instance = build(session: session)
        receiver.public_send "#{attr_name}=", instance
      end

      def self.call(write_message, stream_name, expected_version: nil, session: nil)
        instance = build(session: session)
        instance.(write_message, stream_name, expected_version: expected_version)
      end

      def call(write_message, stream_name, expected_version: nil)
        logger.trace { "Putting message data (Stream Name: #{stream_name}, Type: #{write_message.type}, Expected Version: #{expected_version.inspect})" }
        logger.trace(tags: [:data, :message_data]) { write_message.pretty_inspect }

        write_message.id ||= identifier.get

        id, type, data, metadata = destructure_message(write_message)
        expected_version = ExpectedVersion.canonize(expected_version)

        insert_message(id, stream_name, type, data, metadata, expected_version).tap do |position|
          logger.info { "Put message data (Position: #{position}, Stream Name: #{stream_name}, Type: #{write_message.type}, Expected Version: #{expected_version.inspect}, ID: #{id.inspect})" }
          logger.info(tags: [:data, :message_data]) { write_message.pretty_inspect }
        end
      end

      def destructure_message(write_message)
        id = write_message.id
        type = write_message.type
        data = write_message.data
        metadata = write_message.metadata

        logger.debug(tags: [:data, :message_data]) { "ID: #{id.pretty_inspect}" }
        logger.debug(tags: [:data, :message_data]) { "Type: #{type.pretty_inspect}" }
        logger.debug(tags: [:data, :message_data]) { "Data: #{data.pretty_inspect}" }
        logger.debug(tags: [:data, :message_data]) { "Metadata: #{metadata.pretty_inspect}" }

        return id, type, data, metadata
      end

      def insert_message(id, stream_name, type, data, metadata, expected_version)
        serialized_data = serialized_data(data)
        serialized_metadata = serialized_metadata(metadata)
        records = execute_query(id, stream_name, type, serialized_data, serialized_metadata, expected_version)
        position(records)
      end

      def execute_query(id, stream_name, type, serialized_data, serialized_metadata, expected_version)
        logger.trace { "Executing insert (Stream Name: #{stream_name}, Type: #{type}, Expected Version: #{expected_version.inspect}, ID: #{id.inspect})" }

        params = [
          id,
          stream_name,
          type,
          serialized_data,
          serialized_metadata,
          expected_version
        ]

        begin
          records = session.execute(self.class.statement, params)
        rescue PG::RaiseException => e
          raise_error e
        end

        logger.debug { "Executed insert (Stream Name: #{stream_name}, Type: #{type}, Expected Version: #{expected_version.inspect}, ID: #{id.inspect})" }

        records
      end

      def self.statement
        @statement ||= "SELECT write_event($1::varchar, $2::varchar, $3::varchar, $4::jsonb, $5::jsonb, $6::int);"
      end

      def serialized_data(data)
        serialized_data = nil

        if data.is_a?(Hash) && data.empty?
          data = nil
        end

        unless data.nil?
          serializable_data = MessageData::Hash[data]
          serialized_data = Transform::Write.(serializable_data, :json)
        end

        logger.debug(tags: [:data, :serialize]) { "Serialized Data: #{serialized_data.inspect}" }
        serialized_data
      end

      def serialized_metadata(metadata)
        serialized_metadata = nil

        if metadata.is_a?(Hash) && metadata.empty?
          metadata = nil
        end

        unless metadata.nil?
          serializable_metadata = MessageData::Hash[metadata]
          serialized_metadata = Transform::Write.(serializable_metadata, :json)
        end

        logger.debug(tags: [:data, :serialize]) { "Serialized Metadata: #{serialized_metadata.inspect}" }
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
          logger.error { error_message }
          raise ExpectedVersion::Error, error_message
        end
        raise pg_error
      end
    end
  end
end
