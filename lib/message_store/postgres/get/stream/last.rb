module MessageStore
  module Postgres
    module Get
      class Stream
        class Last
          Error = Class.new(RuntimeError)

          include MessageStore::Get::Stream::Last

          dependency :session, Session

          def configure(session: nil)
            Session.configure(self, session: session)
          end

          def call(stream_name)
            logger.trace(tag: :get) { "Getting last message data (Stream Name: #{stream_name})" }

            result = get_result(stream_name)

            return nil if result.nil?

            message_data = convert(result[0])

            logger.info(tag: :get) { "Finished getting message data (Stream Name: #{stream_name})" }
            logger.info(tags: [:data, :message_data]) { message_data.pretty_inspect }

            message_data
          end

          def get_result(stream_name)
            logger.trace(tag: :get) { "Getting last record (Stream: #{stream_name})" }

            sql_command = self.class.sql_command(stream_name)

            parameter_values = [
              stream_name
            ]


##            result = session.execute(sql_command, params)


            begin
              result = session.execute(sql_command, parameter_values)
            rescue PG::RaiseException => e
              raise_error(e)
            end



            logger.debug(tag: :get) { "Finished getting result (Count: #{result.ntuples}, Stream: #{stream_name}" }

            return nil if result.ntuples == 0

            result
          end

          def self.sql_command(stream_name)
            parameters = '$1::varchar'

            "SELECT * FROM get_last_stream_message(#{parameters});"
          end

          def convert(record)
            logger.trace(tag: :get) { "Converting record to message data" }

            record['data'] = Deserialize.data(record['data'])
            record['metadata'] = Deserialize.metadata(record['metadata'])
            record['time'] = Time.utc_coerced(record['time'])

            message_data = MessageData::Read.build(record)

            logger.debug(tag: :get) { "Converted record to message data" }

            message_data
          end

          def raise_error(pg_error)
            error_message = pg_error.message.gsub('ERROR:', '').strip

            if error_message.start_with?('Must be a stream name')
              logger.error { error_message }
              raise Error, error_message
            end

            raise pg_error
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
end
