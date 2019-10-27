module MessageStore
  module Postgres
    module Get
      def self.included(cls)
        cls.class_exec do
          include MessageStore::Get
          prepend Call
          prepend BatchSize

          extend Parameters

          dependency :session, Session

          initializer :stream_name, na(:batch_size), :correlation, :condition
        end
      end

      module BatchSize
        def batch_size
          @batch_size ||= Defaults.batch_size
        end
      end

      def self.build(stream_name, batch_size: nil, session: nil, correlation: nil, condition: nil)
        cls = specialization(stream_name)

        cls.new(stream_name, batch_size, correlation, condition).tap do |instance|
          instance.configure(session: session)
        end
      end

      def self.configure(receiver, stream_name, attr_name: nil, batch_size: nil, correlation: nil, condition: nil, session: nil)
        attr_name ||= :get
        instance = build(stream_name, batch_size: batch_size, correlation: correlation, condition: condition, session: session)
        receiver.public_send("#{attr_name}=", instance)
      end

      def configure(session: nil)
        Session.configure(self, session: session)
      end

      def self.call(stream_name, position: nil, batch_size: nil, correlation: nil, condition: nil,  session: nil)
        instance = build(stream_name, batch_size: batch_size, correlation: correlation, condition: condition, session: session)
        instance.(position)
      end

      module Call
        def call(position)
          logger.trace(tag: :get) { "Getting message data (Stream Name: #{stream_name}, Position: #{position.inspect}, Batch Size: #{batch_size.inspect}, Condition: #{condition || '(none)'}, Correlation: #{correlation || '(none)'})" }

          position ||= Defaults.position

          result = get_result(stream_name, position)

          message_data = convert(result)

          logger.info(tag: :get) { "Finished getting message data (Count: #{message_data.length}, Stream Name: #{stream_name}, Position: #{position.inspect}, Batch Size: #{batch_size.inspect}, Condition: #{condition || '(none)'}, Correlation: #{correlation || '(none)'})" }
          logger.info(tags: [:data, :message_data]) { message_data.pretty_inspect }

          message_data
        end
      end

      def get_result(stream_name, position)
        logger.trace(tag: :get) { "Getting result (Stream Name: #{stream_name}, Position: #{position.inspect}, Batch Size: #{batch_size.inspect}, Condition: #{condition || '(none)'}, Correlation: #{correlation || '(none)'})" }

        sql_command = self.class.sql_command

        cond = Get.constrain_condition(condition)

        params = [
          stream_name,
          position,
          batch_size,
          correlation,
          cond
        ]

        result = session.execute(sql_command, params)

        logger.debug(tag: :get) { "Finished getting result (Count: #{result.ntuples}, Stream Name: #{stream_name}, Position: #{position.inspect}, Batch Size: #{batch_size.inspect}, Condition: #{condition || '(none)'}, Correlation: #{correlation || '(none)'})" }

        result
      end

      def self.constrain_condition(condition)
        return nil if condition.nil?

        "(#{condition})"
      end

      module Parameters
        def parameters
          '$1::varchar, $2::bigint, $3::bigint, $4::varchar, $5::varchar'
        end
      end

      def convert(result)
        logger.trace(tag: :get) { "Converting result to message data (Result Count: #{result.ntuples})" }

        message_data = result.map do |record|
          record['data'] = Deserialize.data(record['data'])
          record['metadata'] = Deserialize.metadata(record['metadata'])
          record['time'] = Time.utc_coerced(record['time'])

          MessageData::Read.build(record)
        end

        logger.debug(tag: :get) { "Converted result to message data (Message Data Count: #{message_data.length})" }

        message_data
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
        def self.position
          0
        end

        def self.batch_size
          1000
        end
      end
    end
  end
end
