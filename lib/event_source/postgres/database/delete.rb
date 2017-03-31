module EventSource
  module Postgres
    module Database
      module Delete
        def self.call
          warn "Deleting event source database"

          session = Session.build

          User::Delete.(session)
          Database::Delete.(session)

          warn "Done deleting event source database"
        end
      end
    end
  end
end
