module EventSource
  module Postgres
    module Database
      module Functions
        module Create
          def self.call(session)
            Category::Create.(session)
            StreamVersion::Create.(session)
            WriteEvent::Create.(session)
          end

          module Category
            module Create
              def self.sql_filename
                'functions/category.sql'
              end

              def self.call(session)
                sql_code = SQLCode.read sql_filename

                session.execute(sql_code)
              end
            end
          end

          module StreamVersion
            module Create
              def self.sql_filename
                'functions/stream-version.sql'
              end

              def self.call(session)
                sql_code = SQLCode.read sql_filename

                session.execute(sql_code)
              end
            end
          end

          module WriteEvent
            module Create
              def self.sql_filename
                'functions/write-event.sql'
              end

              def self.call(session)
                sql_code = SQLCode.read sql_filename

                session.execute(sql_code)
              end
            end
          end
        end
      end
    end
  end
end
