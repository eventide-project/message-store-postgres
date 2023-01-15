module MessageStore
  module Get
    class Stream
      class Last
        include Dependency
        include Virtual
        include Log::Dependency

        dependency :session, Session

        def self.build(session: nil)
          instance = new
          Session.configure(instance, session: session)
          instance
        end

        def self.call(stream_name, type=nil, session: nil)
          instance = build(session: session)
          instance.(stream_name, type)
        end

        def self.configure(receiver, session: nil, attr_name: nil)
          attr_name ||= :get_last

          instance = build(session: session)
          receiver.public_send("#{attr_name}=", instance)
          instance
        end

        def call(stream_name, type=nil)
          logger.trace(tag: :get) { "Getting last message data (Stream Name: #{stream_name})" }

          result = get_result(stream_name, type)

          return nil if result.nil?

          message_data = convert(result[0])

          logger.info(tag: :get) { "Finished getting message data (Stream Name: #{stream_name})" }
          logger.info(tags: [:data, :message_data]) { message_data.pretty_inspect }

          message_data
        end

        def get_result(stream_name, type)
          logger.trace(tag: :get) { "Getting last record (Stream: #{stream_name})" }

          parameter_values = parameter_values(stream_name, type)
          sql_command = sql_command(type)

          result = session.execute(sql_command, parameter_values)

          logger.debug(tag: :get) { "Finished getting result (Count: #{result.ntuples}, Stream: #{stream_name}" }

          return nil if result.ntuples == 0

          result
        end

        def sql_command(type)
          parameters = parameters(type)

          "SELECT * FROM get_last_stream_message(#{parameters});"
        end

        def parameters(type)
          parameters = "$1::varchar"

          # Backwards compatibility with versions of message-db that do not
          # support the type parameter - Aaron, Scott, Tue Jul 12 2022
          if not type.nil?
            parameters << ", $2::varchar"
          end

          parameters
        end

        def parameter_values(stream_name, type)
          parameter_values = [
            stream_name
          ]

          # Backwards compatibility with versions of message-db that do not
          # support the type parameter - Aaron, Scott, Tue Jul 12 2022
          if not type.nil?
            parameter_values << type
          end

          parameter_values
        end

        def convert(record)
          logger.trace(tag: :get) { "Converting record to message data" }

          message_data = Get.message_data(record)

          logger.debug(tag: :get) { "Converted record to message data" }

          message_data
        end
      end
    end
  end
end
