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

            session.execute(sql_code)
          end
        end
      end
    end
  end
end
