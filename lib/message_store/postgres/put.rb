module MessageStore
  module Postgres
    class Put
      include Dependency
      include Log::Dependency

      dependency :session, Session
      dependency :identifier, Identifier::UUID::Random

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
        logger.trace(tag: :put) { "Putting message data (Type: #{write_message.type}, Stream Name: #{stream_name}, Expected Version: #{expected_version.inspect})" }
        logger.trace(tags: [:data, :message_data]) { write_message.pretty_inspect }

        write_message.id ||= identifier.get

        id, type, data, metadata = destructure_message(write_message)
        expected_version = ExpectedVersion.canonize(expected_version)

        insert_message(id, stream_name, type, data, metadata, expected_version).tap do |position|
          logger.info(tag: :put) { "Put message data (Type: #{write_message.type}, Stream Name: #{stream_name}, Expected Version: #{expected_version.inspect}, ID: #{id.inspect}, Position: #{position})" }
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
        transformed_data = transformed_data(data)
        transformed_metadata = transformed_metadata(metadata)
        records = execute_query(id, stream_name, type, transformed_data, transformed_metadata, expected_version)
        position(records)
      end

      def execute_query(id, stream_name, type, transformed_data, transformed_metadata, expected_version)
        logger.trace(tag: :put) { "Executing insert (Stream Name: #{stream_name}, Type: #{type}, Expected Version: #{expected_version.inspect}, ID: #{id.inspect})" }

        params = [
          id,
          stream_name,
          type,
          transformed_data,
          transformed_metadata,
          expected_version
        ]

        begin
          records = session.execute(self.class.statement, params)
        rescue PG::RaiseException => e
          raise_error e
        end

        logger.debug(tag: :put) { "Executed insert (Type: #{type}, Stream Name: #{stream_name}, Expected Version: #{expected_version.inspect}, ID: #{id.inspect})" }

        records
      end

      def self.statement
        @statement ||= "SELECT write_message($1::varchar, $2::varchar, $3::varchar, $4::jsonb, $5::jsonb, $6::bigint);"
      end

      def transformed_data(data)
        transformed_data = nil

        if data.is_a?(Hash) && data.empty?
          data = nil
        end

        unless data.nil?
          transformable_data = MessageData::Hash[data]
          transformed_data = Transform::Write.(transformable_data, :json)
        end

        logger.debug(tags: [:data, :serialize]) { "Transformed Data: #{transformed_data.inspect}" }
        transformed_data
      end

      def transformed_metadata(metadata)
        transformed_metadata = nil

        if metadata.is_a?(Hash) && metadata.empty?
          metadata = nil
        end

        unless metadata.nil?
          transformable_metadata = MessageData::Hash[metadata]
          transformed_metadata = Transform::Write.(transformable_metadata, :json)
        end

        logger.debug(tags: [:data, :serialize]) { "Transformed Metadata: #{transformed_metadata.inspect}" }
        transformed_metadata
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
