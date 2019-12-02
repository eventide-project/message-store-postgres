module MessageStore
  module Postgres
    module Get
      class Stream
        Error = Class.new(RuntimeError)

        include Get

        initializer :stream_name, na(:batch_size), :condition

        def self.call(stream_name, position: nil, batch_size: nil, condition: nil, session: nil)
          instance = build(stream_name, batch_size: batch_size, condition: condition, session: session)
          instance.(position)
        end

        def self.build(stream_name, batch_size: nil, condition: nil, session: nil)
          instance = new(stream_name, batch_size, condition)
          instance.configure(session: session)
          instance
        end

        def self.configure(receiver, stream_name, attr_name: nil, batch_size: nil, condition: nil, session: nil)
          attr_name ||= :get
          instance = build(stream_name, batch_size: batch_size, condition: condition, session: session)
          receiver.public_send("#{attr_name}=", instance)
        end

        def configure(session: nil)
          Session.configure(self, session: session)
        end

        def sql_command
          "SELECT * FROM get_stream_messages(#{parameters});"
        end

        def parameters
          '$1::varchar, $2::bigint, $3::bigint, $4::varchar'
        end

        def parameter_values(stream_name, position)
          [
            stream_name,
            position,
            batch_size,
            condition
          ]
        end

        def last_position(batch)
          batch.last.position
        end

        def log_text(stream_name, position)
          "Stream Name: #{stream_name}, Position: #{position.inspect}, Batch Size: #{batch_size.inspect}, Correlation: #{correlation.inspect}, Condition: #{condition.inspect})"
        end

        def assure
          if MessageStore::StreamName.category?(stream_name)
            raise Error, "Must be a stream name (Category: #{stream_name})"
          end
        end

        module Defaults
          def self.position
            0
          end
        end
      end
    end
  end
end
