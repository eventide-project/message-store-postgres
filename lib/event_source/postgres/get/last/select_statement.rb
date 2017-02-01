module EventSource
  module Postgres
    class Get
      class Last
        class SelectStatement
          include Log::Dependency

          initializer :stream_name

          def self.build(stream_name)
            new(stream_name)
          end

          def sql
            logger.trace(tag: :sql) { "Composing select statement (Stream: #{stream_name})" }

            statement = <<-SQL
              SELECT
                id::varchar,
                stream_name::varchar,
                position::int,
                type::varchar,
                global_position::bigint,
                data::varchar,
                metadata::varchar,
                time::timestamp
              FROM
                events
              WHERE
                stream_name = '#{stream_name}'
              ORDER BY
                position DESC
              LIMIT
                1
              ;
            SQL

            logger.debug(tag: :sql) { "Composed select statement (Stream: #{stream_name})" }
            logger.debug(tags: [:data, :sql]) { "Statement: #{statement}" }

            statement
          end
        end
      end
    end
  end
end
