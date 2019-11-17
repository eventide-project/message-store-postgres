module MessageStore
  module Postgres
    module Get
      class Category
        include Get

##        def self.sql_command
        def sql_command
          "SELECT * FROM get_category_messages(#{parameters});"
        end

        def parameter_names
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

        module Defaults
          def self.position
            1
          end
        end
      end
    end
  end
end
