module EventSource
  module Postgres
    module Database
      module Recreate
        def self.call
          Delete.()
          Create.()
        end
      end
    end
  end
end
