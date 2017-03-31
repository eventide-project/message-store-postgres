module EventSource
  module Postgres
    module Database
      class Session < Postgres::Session
        def self.build
          instance = new
          settings = Settings.build({})
          settings.set(instance)
          instance
        end
      end
    end
  end
end
