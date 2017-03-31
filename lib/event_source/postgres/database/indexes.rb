module EventSource
  module Postgres
    module Database
      module Indexes
        module Create
          def self.sql_filename
            'indexes/events-indexes.sql'
          end

          def self.call(session)
            sql_code = SQLCode.read sql_filename

            sql_statements = sql_code.split ';'

            sql_statements.each do |sql_statement|
              session.execute(sql_statement)
            end
          end
        end
      end
    end
  end
end
