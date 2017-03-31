module EventSource
  module Postgres
    module Database
      module Create
        def self.call
          session = Session.build

          User::Create.(session)
          Database::Create.(session)
          Extensions::Create.(session)
          Table::Create.(session)
          Functions::Create.(session)
          Indexes::Create.(session)
        end
      end
    end
  end
end
