module EventSource
  module Postgres
    module Database
      module Delete
        def self.call
          settings = Settings.build(Hash.new)
          session = Session.build(settings: settings)

          user = ENV['DATABASE_USER'] || 'event_source'
          database = ENV['DATABASE_NAME'] || 'event_source'

          session.execute("DROP USER IF EXISTS #{user}")
          session.execute("DROP DATABASE IF EXISTS #{database}")
        end
      end
    end
  end
end
