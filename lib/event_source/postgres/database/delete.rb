module EventSource
  module Postgres
    module Database
      module Delete
        def self.call
          warn "Deleting database"

          session = Session.build

          User::Delete.(session)
          Database::Delete.(session)

          warn "Done deleting database"
        end
      end
    end
  end
end
