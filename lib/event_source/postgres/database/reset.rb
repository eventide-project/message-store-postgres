module EventSource
  module Postgres
    module Database
      module Reset
        def self.call
          Delete.()
          Create.()
        end
      end
    end
  end
end
