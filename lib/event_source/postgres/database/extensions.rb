module EventSource
  module Postgres
    module Database
      module Extensions
        module Create
          def self.sql_filename
            'database/extensions.sql'
          end

          def self.call(session)
            session.execute(sql_code)
          end
        end
      end
    end
  end
end
