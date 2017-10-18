module MessageStore
  module Postgres
    class Get
      include MessageStore::Get

      initializer :batch_size, :condition

      dependency :session, Session

      def self.build(batch_size: nil, session: nil, condition: nil)
        new(batch_size, condition).tap do |instance|
          instance.configure(session: session)
        end
      end

      def self.configure(receiver, attr_name: nil, position: nil, batch_size: nil, condition: nil, session: nil)
        attr_name ||= :get
        instance = build(batch_size: batch_size, condition: condition, session: session)
        receiver.public_send "#{attr_name}=", instance
      end

      def configure(session: nil)
        Session.configure self, session: session
      end

      def self.call(stream_name, position: nil, batch_size: nil, condition: nil,  session: nil)
        instance = build(batch_size: batch_size, condition: condition, session: session)
        instance.(stream_name, position: position)
      end

      def call(stream_name, position: nil)
        logger.trace { "Getting message data (Position: #{position.inspect}, Stream Name: #{stream_name}, Batch Size: #{batch_size.inspect})" }

        records = get_records(stream_name, position)

        messages = convert(records)

        logger.info { "Finished getting message data (Count: #{messages.length}, Position: #{position.inspect}, Stream Name: #{stream_name}, Batch Size: #{batch_size.inspect})" }
        logger.info(tags: [:data, :message_data]) { messages.pretty_inspect }

        messages
      end

      def get_records(stream_name, position)
        logger.trace { "Getting records (Stream: #{stream_name}, Position: #{position.inspect}, Batch Size: #{batch_size.inspect}, Condition: #{condition || '(none)'})" }

        where_fragment = self.condition

        select_statement = SelectStatement.build(stream_name, position: position, batch_size: batch_size, condition: condition)

        records = session.execute(select_statement.sql)

        logger.debug { "Finished getting records (Count: #{records.ntuples}, Stream: #{stream_name}, Position: #{position.inspect}, Batch Size: #{batch_size.inspect}, Condition: #{condition || '(none)'})" }

        records
      end

      def convert(records)
        logger.trace { "Converting records to message data (Records Count: #{records.ntuples})" }

        messages = records.map do |record|
          record['data'] = Deserialize.data(record['data'])
          record['metadata'] = Deserialize.metadata(record['metadata'])
          record['time'] = Time.utc_coerced(record['time'])

          MessageData::Read.build record
        end

        logger.debug { "Converted records to message data (Message Data Count: #{messages.length})" }

        messages
      end

      module Deserialize
        def self.data(serialized_data)
          return nil if serialized_data.nil?
          Transform::Read.(serialized_data, MessageData::Hash, :json)
        end

        def self.metadata(serialized_metadata)
          return nil if serialized_metadata.nil?
          Transform::Read.(serialized_metadata, MessageData::Hash, :json)
        end
      end

      module Time
        def self.utc_coerced(local_time)
          Clock::UTC.coerce(local_time)
        end
      end
    end
  end
end
