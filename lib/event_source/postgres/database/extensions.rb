module EventSource
  module Postgres
    module Database
      module Extensions
        module Create
          def self.sql_filename
            'extensions.sql'
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
