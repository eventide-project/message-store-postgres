module MessageStore
  module Postgres
    class Get
      class SelectStatement
        include Log::Dependency

        initializer :stream_name, w(:position), w(:batch_size), :condition

        def position
          @position ||= Defaults.position
        end

        def batch_size
          @batch_size ||= Defaults.batch_size
        end

        def stream_type_list
          @stream_type ||= StreamName.get_type_list(stream_name)
        end

        def category_stream?
          is_category_stream ||= StreamName.category?(stream_name)
        end

        def self.build(stream_name, position: nil, batch_size: nil, condition: nil)
          new(stream_name, position, batch_size, condition)
        end

        def sql
          logger.trace(tag: :sql) { "Composing select statement (Stream: #{stream_name}, Category: #{category_stream?}, Types: #{stream_type_list.inspect}, Position: #{position}, Batch Size: #{batch_size})" }

          formatted_where_clause = where_clause.each_line.to_a.join("  ")

          statement = <<~SQL
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
              messages
            WHERE
              #{formatted_where_clause}
            ORDER BY
              #{position_field} ASC
            LIMIT
              #{batch_size}
            ;
          SQL

          logger.debug(tag: :sql) { "Composed select statement (Stream: #{stream_name}, Category: #{category_stream?}, Types: #{stream_type_list.inspect}, Position: #{position}, Batch Size: #{batch_size})" }
          logger.debug(tags: [:data, :sql]) { "Statement: #{statement}" }

          statement
        end

        def where_clause
          clause = <<~SQL.chomp
            #{where_clause_field} = '#{stream_name}' AND
            #{position_field} >= #{position}
          SQL

          unless condition.nil?
            clause << " AND\n(#{condition})"
          end

          clause
        end

        def where_clause_field
          unless category_stream?
            'stream_name'
          else
            'category(stream_name)'
          end
        end

        def position_field
          unless category_stream?
            'position'
          else
            'global_position'
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
end
