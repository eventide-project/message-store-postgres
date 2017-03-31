module EventSource
  module Postgres
    module Database
      module Database
        module Create
          def self.call(session)
            database = Settings.database

            begin
              session.execute("CREATE DATABASE #{database}")
            rescue PG::DuplicateDatabase
              warn "NOTICE:  database \"#{database}\" already exists, skipping"
            end
          end
        end

        module Delete
          def self.call(session)
            database = Settings.database
            session.execute("DROP DATABASE IF EXISTS #{database}")
          end
        end
      end
    end
  end
end
