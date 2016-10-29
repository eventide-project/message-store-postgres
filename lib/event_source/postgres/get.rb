module EventSource
  module Postgres
    class Get
      include Log::Dependency

      initializer :stream, :batch_size, :precedence, :partition

      dependency :session, Session

      def self.build(stream, batch_size: nil, precedence: nil, partition: nil, session: nil)
        new(stream, batch_size, precedence, partition).tap do |instance|
          instance.configure(session: session)
        end
      end

      def self.configure(receiver, stream, attr_name: nil, position: nil, batch_size: nil, precedence: nil, partition: nil, session: nil)
        attr_name ||= :get
        instance = build(stream, batch_size: batch_size, precedence: precedence, partition: partition, session: session)
        receiver.public_send "#{attr_name}=", instance
      end

      def self.call(stream, position: nil, batch_size: nil, precedence: nil, partition: nil, session: nil)
        instance = build(stream, batch_size: batch_size, precedence: precedence, partition: partition, session: session)
        instance.(position: position)
      end

      def configure(session: nil)
        Session.configure self, session: session
      end

      def call(position: nil)
        logger.trace { "Getting event data (Position: #{position.inspect}, Stream Name: #{stream.name}, Category: #{stream.category?}, Batch Size: #{batch_size.inspect}, Precedence: #{precedence.inspect}, Partition: #{partition.inspect})" }

        records = get_records(stream, position)

        events = convert(records)

        logger.debug { "Finished getting event data (Count: #{events.length}, Position: #{position.inspect}, Stream Name: #{stream.name}, Category: #{stream.category?}, Batch Size: #{batch_size.inspect}, Precedence: #{precedence.inspect}, Partition: #{partition.inspect})" }

        events
      end

      def get_records(stream, position)
        logger.trace { "Getting records (Stream: #{stream.name}, Category: #{stream.category?}, Position: #{position.inspect}, Batch Size: #{batch_size.inspect}, Precedence: #{precedence.inspect}, Partition: #{partition.inspect})" }

        select_statement = SelectStatement.build(stream, offset: position, batch_size: batch_size, precedence: precedence, partition: partition)

        records = session.connection.exec(select_statement.sql)

        logger.debug { "Finished getting records (Count: #{records.ntuples}, Stream: #{stream.name}, Category: #{stream.category?}, Position: #{position.inspect}, Batch Size: #{batch_size.inspect}, Precedence: #{precedence.inspect}, Partition: #{partition.inspect})" }

        records
      end

      def convert(records)
        logger.trace { "Converting records to event data (Records Count: #{records.ntuples})" }

        events = records.map do |record|
          record['data'] = Deserialize.data(record['data'])
          record['metadata'] = Deserialize.metadata(record['metadata'])
          record['created_time'] = Time.utc_coerced(record['created_time'])

          EventData::Read.build record
        end

        logger.debug { "Converted records to event data (Event Data Count: #{events.length})" }

        events
      end

      module Deserialize
        def self.data(serialized_data)
          Transform::Read.(serialized_data, EventData::Hash, :json)
        end

        def self.metadata(serialized_metadata)
          if serialized_metadata.nil?
            nil
          else
            Transform::Read.(serialized_metadata, EventData::Hash, :json)
          end
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
