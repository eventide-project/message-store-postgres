module MessageStore
  module Postgres
    module Get
      def self.included(cls)
        cls.class_exec do
          include MessageStore::Get

          prepend Call
          prepend BatchSize

          dependency :session, Session

          template_method! :stream_name
          template_method! :sql_command
          template_method! :parameters
          template_method! :parameter_values
          template_method! :last_position
          template_method! :log_text

          template_method :specialize_error
          template_method :assure
        end
      end

      module BatchSize
        def batch_size
          @batch_size ||= Defaults.batch_size
        end
      end

      def self.build(stream_name, **args)
        cls = specialization(stream_name)
        cls.build(stream_name, **args)
      end

      def self.configure(receiver, stream_name, **args)
        attr_name = args.delete(:attr_name)
        attr_name ||= :get

        instance = build(stream_name, **args)
        receiver.public_send("#{attr_name}=", instance)
      end

      def configure(session: nil)
        Session.configure(self, session: session)
      end

      def self.call(stream_name, **args)
        position = args.delete(:position)
        instance = build(stream_name, **args)
        instance.(position)
      end

      module Call
        def call(position=nil, stream_name: nil)
          position ||= self.class::Defaults.position

          stream_name ||= self.stream_name

          assure

          logger.trace(tag: :get) { "Getting message data (#{log_text(stream_name, position)})" }

          result = get_result(stream_name, position)

          message_data = convert(result)

          logger.info(tag: :get) { "Finished getting message data (Count: #{message_data.length}, #{log_text(stream_name, position)})" }
          logger.info(tags: [:data, :message_data]) { message_data.pretty_inspect }

          message_data
        end
      end

      def get_result(stream_name, position)
        logger.trace(tag: :get) { "Getting result (#{log_text(stream_name, position)})" }

        parameter_values = parameter_values(stream_name, position)

        begin
          result = session.execute(sql_command, parameter_values)
        rescue PG::RaiseException => e
          raise_error(e)
        end

        logger.debug(tag: :get) { "Finished getting result (Count: #{result.ntuples}, #{log_text(stream_name, position)})" }

        result
      end

      def convert(result)
        logger.trace(tag: :get) { "Converting result to message data (Result Count: #{result.ntuples})" }

        message_data = result.map do |record|
          Get.message_data(record)
        end

        logger.debug(tag: :get) { "Converted result to message data (Message Data Count: #{message_data.length})" }

        message_data
      end

      def self.message_data(record)
        record['data'] = Get::Deserialize.data(record['data'])
        record['metadata'] = Get::Deserialize.metadata(record['metadata'])
        record['time'] = Get::Time.utc_coerced(record['time'])

        MessageData::Read.build(record)
      end

      def raise_error(pg_error)
        error_message = Get.error_message(pg_error)

        error = Condition.error(error_message)

        if error.nil?
          error = specialize_error(error_message)
        end

        if not error.nil?
          logger.error { error_message }
          raise error
        end

        raise pg_error
      end

      def self.error_message(pg_error)
        pg_error.message.gsub('ERROR:', '').strip
      end

      def self.specialization(stream_name)
        if StreamName.category?(stream_name)
          Category
        else
          Stream
        end
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

      module Defaults
        def self.batch_size
          1000
        end
      end
    end
  end
end
