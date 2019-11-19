module MessageStore
  module Postgres
    module Get
      class Stream
        include Get

        initializer :stream_name, na(:batch_size), :correlation, :condition

        def self.build(stream_name, batch_size: nil, correlation: nil, condition: nil)
          new(stream_name, batch_size, correlation, condition)
        end

        def sql_command
          "SELECT * FROM get_stream_messages(#{parameters});"
        end

        def parameters
          '$1::varchar, $2::bigint, $3::bigint, $4::varchar, $5::varchar'
        end

        def parameter_values(stream_name, position)
          [
            stream_name,
            position,
            batch_size,
            correlation,
            condition
          ]
        end

        def last_position(batch)
          batch.last.position
        end

        def log_text(position, stream_name)
          "Stream Name: #{stream_name}, Position: #{position.inspect}, Batch Size: #{batch_size.inspect}, Correlation: #{correlation.inspect}, Condition: #{condition.inspect})"
        end

        def self.assure(stream_name, args)
          if args.include?(:consumer_group_member) || args.include?(:consumer_group_size)
            raise Error, "Consumer groups are only supported for category retrieval (Stream Name: #{stream_name})"
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
