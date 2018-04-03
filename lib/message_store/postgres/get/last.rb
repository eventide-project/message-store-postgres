module MessageStore
  module Postgres
    class Get
      class Last
        include MessageStore::Get::Last

        dependency :session, Session

        def configure(session: nil)
          Session.configure(self, session: session)
        end

        def call(stream_name)
          logger.trace { "Getting last message data (Stream Name: #{stream_name})" }

          record = get_record(stream_name)

          return nil if record.nil?

          message_data = convert(record)

          logger.info { "Finished getting message data (Stream Name: #{stream_name})" }
          logger.info(tags: [:data, :message_data]) { message_data.pretty_inspect }

          message_data
        end

        def get_record(stream_name)
          logger.trace { "Getting last record (Stream: #{stream_name})" }

          select_statement = SelectStatement.build(stream_name)

          records = session.execute(select_statement.sql)

          logger.debug { "Finished getting record (Stream: #{stream_name})" }

          return nil if records.ntuples == 0

          records[0]
        end

        def convert(record)
          logger.trace { "Converting record to message data" }

          record['data'] = Deserialize.data(record['data'])
          record['metadata'] = Deserialize.metadata(record['metadata'])
          record['time'] = Time.utc_coerced(record['time'])

          message_data = MessageData::Read.build(record)

          logger.debug { "Converted record to message data" }

          message_data
        end

        def __convert(records)
          logger.trace { "Converting records to message data (Records Count: #{records.ntuples})" }

          messages = records.map do |record|
            record['data'] = Deserialize.data(record['data'])
            record['metadata'] = Deserialize.metadata(record['metadata'])
            record['time'] = Time.utc_coerced(record['time'])

            MessageData::Read.build record

            break
          end

          logger.debug { "Converted records to message data (Message Data Count: #{messages.length})" }

          messages
        end

        module Deserialize
          def self.data(serialized_data)
            return nil if serialized_data.nil?
            Transform::Read.(serialized_data, :json, MessageData::Hash)
          end

          def self.metadata(serialized_metadata)
            return nil if serialized_metadata.nil?
            Transform::Read.(serialized_metadata, :json, MessageData::Hash)
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
end
