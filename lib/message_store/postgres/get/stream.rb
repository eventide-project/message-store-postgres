module MessageStore
  module Postgres
    module Get
      class Stream
        include Get

        def sql_command
          "SELECT * FROM get_stream_messages(#{parameter_names});"
        end

        def parameter_names
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

        module Defaults
          def self.position
            0
          end
        end
      end
    end
  end
end
