module EventStream
  module Postgres
    class Get
      class SelectStatement
        initializer :stream, w(:offset), w(:batch_size), w(:precedence)

        dependency :logger, Telemetry::Logger

        def offset
          @offset ||= Defaults.offset
        end

        def batch_size
          @batch_size ||= Defaults.batch_size
        end

        def precedence
          @precedence ||= Defaults.precedence
        end

        def stream_name
          stream.name
        end

        def stream_type
          stream.type
        end

        def self.build(stream, offset: nil, batch_size: nil, precedence: nil)
          new(stream, offset, batch_size, precedence).tap do |instance|
            instance.configure
          end
        end

        def configure
          Telemetry::Logger.configure self
        end

        def sql
          logger.opt_trace "Composing select statement (Stream: #{stream_name}, Type: #{stream_type}, Stream Position: #{offset}, Batch Size: #{batch_size}, Precedence: #{precedence})"

          statement = <<-SQL
            SELECT
              stream_name::varchar,
              stream_position::int,
              type::varchar,
              global_position::bigint,
              data::varchar,
              metadata::varchar,
              created_time::timestamp
            FROM
              events
            WHERE
              #{where_clause_field} = '#{stream_name}'
            ORDER BY
              global_position #{precedence.to_s.upcase}
            LIMIT
              #{batch_size}
            OFFSET
              #{offset}
            ;
          SQL

          logger.opt_debug "Composed select statement (Stream: #{stream_name}, Type: #{stream_type}, Stream Position: #{offset}, Batch Size: #{batch_size}, Precedence: #{precedence})"
          logger.opt_data "Statement: #{statement}"

          statement
        end

        def where_clause_field
          if stream.type == :stream
            'stream_name'
          else
            'category(stream_name)'
          end
        end

        module Defaults
          def self.offset
            0
          end

          def self.batch_size
            1000
          end

          def self.precedence
            :asc
          end
        end
      end
    end
  end
end
