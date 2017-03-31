module EventSource
  module Postgres
    module Database
      module Delete
        def self.call
          session = Session.build

          User::Delete.(session)
          Database::Delete.(session)
        end
      end
    end
  end
end
