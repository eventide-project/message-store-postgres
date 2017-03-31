module EventSource
  module Postgres
    module Database
      module Create
        def self.call
          session = Session.build

          user = ENV['DATABASE_USER'] || 'event_source'
          password = ENV['DATABASE_PASSWORD']
          database = ENV['DATABASE_NAME'] || 'event_source'

          create_user_statement = "CREATE USER #{user}"
          create_user_statement << " PASSWORD #{password}" unless password.nil?

          begin
            session.execute(create_user_statement)
          rescue PG::DuplicateObject
            warn "NOTICE:  role \"#{user}\" already exists, skipping"
          end

          begin
            session.execute("CREATE DATABASE #{database}")
          rescue PG::DuplicateDatabase
            warn "NOTICE:  database \"#{database}\" already exists, skipping"
          end
        end
      end
    end
  end
end
