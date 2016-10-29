module EventSource
  module Postgres
    class Get
      class SelectStatement
        include Log::Dependency

        initializer :stream, w(:offset), w(:batch_size), w(:precedence), w(:partition)

        def offset
          @offset ||= Defaults.offset
        end

        def batch_size
          @batch_size ||= Defaults.batch_size
        end

        def precedence
          @precedence ||= Defaults.precedence
        end

        def partition
          @partition ||= Defaults.partition
        end

        def stream_name
          stream.name
        end

        def stream_type
          stream.type
        end

        def self.build(stream, offset: nil, batch_size: nil, partition: nil, precedence: nil)
          new(stream, offset, batch_size, precedence, partition)
        end

        def sql
          logger.trace(tag: :sql) { "Composing select statement (Stream: #{stream_name}, Category: #{stream.category?}, Type: #{stream_type}, Position: #{offset}, Batch Size: #{batch_size}, Precedence: #{precedence}, Partition: #{partition})" }

          statement = <<-SQL
            SELECT
              stream_name::varchar,
              position::int,
              type::varchar,
              global_position::bigint,
              data::varchar,
              metadata::varchar,
              recorded_time::timestamp
            FROM
              #{partition}
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

          logger.debug(tag: :sql) { "Composed select statement (Stream: #{stream_name}, Category: #{stream.category?}, Type: #{stream_type}, Position: #{offset}, Batch Size: #{batch_size}, Precedence: #{precedence}, Partition: #{partition.inspect})" }
          logger.debug(tags: [:data, :sql]) { "Statement: #{statement}" }

          statement
        end

        def where_clause_field
          unless stream.category?
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

          def self.partition
            Partition::Defaults.name
          end
        end
      end
    end
  end
end
