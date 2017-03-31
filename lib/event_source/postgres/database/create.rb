module EventSource
  module Postgres
    module Database
      module Create
        def self.call
          warn "Creating event source database"

          session = Session.build

          User::Create.(session)
          Database::Create.(session)
          Extensions::Create.(session)
          Table::Create.(session)
          Functions::Create.(session)
          Indexes::Create.(session)

          warn "Done creating event source database"
        end
      end
    end
  end
end
