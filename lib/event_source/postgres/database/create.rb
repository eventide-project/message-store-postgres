module EventSource
  module Postgres
    module Database
      module Create
        def self.call
          session = Session.build

          User::Create.(session)
          Database::Create.(session)
          Table::Create.(session)
        end
      end
    end
  end
end
