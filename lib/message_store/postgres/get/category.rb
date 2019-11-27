module MessageStore
  module Postgres
    module Get
      class Category
        Error = Class.new(RuntimeError)

        include Get

        initializer :stream_name, na(:batch_size), :correlation, :consumer_group_member, :consumer_group_size, :condition

        def self.build(stream_name, batch_size: nil, correlation: nil, consumer_group_member: nil, consumer_group_size: nil, condition: nil)
          new(stream_name, batch_size, correlation, consumer_group_member, consumer_group_size, condition)
        end

        def sql_command
          "SELECT * FROM get_category_messages(#{parameters});"
        end

        def parameters
          '$1::varchar, $2::bigint, $3::bigint, $4::varchar, $5::bigint, $6::bigint, $7::varchar'
        end

        def parameter_values(stream_name, position)
          [
            stream_name,
            position,
            batch_size,
            correlation,
            consumer_group_member,
            consumer_group_size,
            condition
          ]
        end

        def last_position(batch)
          batch.last.global_position
        end

        def log_text(stream_name, position)
          "Stream Name: #{stream_name}, Position: #{position.inspect}, Batch Size: #{batch_size.inspect}, Correlation: #{correlation.inspect}, Consumer Group Member: #{consumer_group_member.inspect}, Consumer Group Size: #{consumer_group_size.inspect}, Condition: #{condition.inspect})"
        end

        module Defaults
          def self.position
            1
          end
        end
      end
    end
  end
end
