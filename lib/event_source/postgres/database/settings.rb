module EventSource
  module Postgres
    module Database
      module Settings
        def self.user
          ENV['DATABASE_USER'] || 'event_source'
        end

        def self.password
          ENV['DATABASE_PASSWORD']
        end

        def self.database
          ENV['DATABASE_NAME'] || 'event_source'
        end
      end
    end
  end
end
