module EventSource
  module Postgres
    module Database
      module User
        module Create
          def self.call(session)
            user = Settings.user
            password = Settings.password

            create_user_statement = "CREATE USER #{user}"
            create_user_statement << " PASSWORD #{password}" unless password.nil?

            begin
              session.execute(create_user_statement)
            rescue PG::DuplicateObject
              warn "NOTICE:  role \"#{user}\" already exists, skipping"
            end
          end
        end

        module Delete
          def self.call(session)
            user = Settings.user
            session.execute("DROP USER IF EXISTS #{user}")
          end
        end
      end
    end
  end
end
