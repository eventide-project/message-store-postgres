module EventSource
  module Postgres
    module Database
      module Table
        module Create
          def self.sql_filename
            'table/events-table.sql'
          end

          def self.call(session)
            sql_code = SQLCode.read sql_filename

            session.execute(sql_code)
          end
        end
      end
    end
  end
end
