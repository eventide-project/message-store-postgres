module EventSource
  module Postgres
    module Database
      module Table
        module Create
          def self.sql_filename
            'table/events-table.sql'
          end

          def self.call(session)
          end
        end
      end
    end
  end
end
