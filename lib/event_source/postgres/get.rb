module EventSource
  module Postgres
    class Get
      include Log::Dependency

      initializer :stream, :batch_size, :precedence

      dependency :session, Session

      def self.build(stream, batch_size: nil, precedence: nil, session: nil)
        new(stream, batch_size, precedence).tap do |instance|
          instance.configure(session: session)
        end
      end

      def self.configure(receiver, stream, attr_name: nil, stream_position: nil, batch_size: nil, precedence: nil, session: nil)
        attr_name ||= :get
        instance = build(stream, batch_size: batch_size, precedence: precedence, session: session)
        receiver.public_send "#{attr_name}=", instance
      end

      def self.call(stream, stream_position: nil, batch_size: nil, precedence: nil, session: nil)
        instance = build(stream, batch_size: batch_size, precedence: precedence, session: session)
        instance.(stream_position: stream_position)
      end

      def configure(session: nil)
        Session.configure self, session: session
      end

      def call(stream_position: nil)
        logger.trace "Getting event data (Stream Position: #{stream_position.inspect}, Stream Name: #{stream.name}, Category: #{stream.category?}, Batch Size: #{batch_size.inspect}, Precedence: #{precedence.inspect})"

        records = get_records(stream, stream_position)

        events = convert(records)

        logger.debug "Finished getting event data (Count: #{events.length}, Stream Position: #{stream_position.inspect}, Stream Name: #{stream.name}, Category: #{stream.category?}, Batch Size: #{batch_size.inspect}, Precedence: #{precedence.inspect})"

        events
      end

      def get_records(stream, stream_position)
        logger.trace "Getting records (Stream: #{stream.name}, Category: #{stream.category?}, Stream Position: #{stream_position.inspect}, Batch Size: #{batch_size.inspect}, Precedence: #{precedence.inspect})"

        select_statement = SelectStatement.build(stream, offset: stream_position, batch_size: batch_size, precedence: precedence)

        records = session.connection.exec(select_statement.sql)

        logger.debug "Finished getting records (Count: #{records.ntuples}, Stream: #{stream.name}, Category: #{stream.category?}, Stream Position: #{stream_position.inspect}, Batch Size: #{batch_size.inspect}, Precedence: #{precedence.inspect})"

        records
      end

      def convert(records)
        logger.trace "Converting records to event data (Records Count: #{records.ntuples})"

        events = records.map do |record|
          record['data'] = Deserialize.data(record['data'])
          record['metadata'] = Deserialize.metadata(record['metadata'])
          record['created_time'] = Time.utc_coerced(record['created_time'])

          EventData::Read.build record
        end

        logger.debug "Converted records to event data (Event Data Count: #{events.length})"

        events
      end

      module Deserialize
        def self.data(serialized_data)
          Serialize::Read.(serialized_data, EventData::Hash, :json)
        end

        def self.metadata(serialized_metadata)
          if serialized_metadata.nil?
            nil
          else
            Serialize::Read.(serialized_metadata, EventData::Hash, :json)
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
