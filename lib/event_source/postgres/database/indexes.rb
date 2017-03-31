module EventSource
  module Postgres
    module Database
      module Indexes
        module Create
          def self.call(session)
            Category::GlobalPosition::Create.(session)
            Category::Create.(session)
            ID::Create.(session)
            StreamName::PositionUniq::Create.(session)
            StreamName::Create.(session)
          end

          module Category
            module Create
              def self.sql_filename
                'indexes/events-category.sql'
              end

              def self.call(session)
                sql_code = SQLCode.read sql_filename

                session.execute(sql_code)
              end
            end

            module GlobalPosition
              module Create
                def self.sql_filename
                  'indexes/events-category-global-position.sql'
                end

                def self.call(session)
                  sql_code = SQLCode.read sql_filename

                  session.execute(sql_code)
                end
              end
            end
          end

          module ID
            module Create
              def self.sql_filename
                'indexes/events-id.sql'
              end

              def self.call(session)
                sql_code = SQLCode.read sql_filename

                session.execute(sql_code)
              end
            end
          end

          module StreamName
            module Create
              def self.sql_filename
                'indexes/events-stream-name.sql'
              end

              def self.call(session)
                sql_code = SQLCode.read sql_filename

                session.execute(sql_code)
              end
            end

            module PositionUniq
              module Create
                def self.sql_filename
                  'indexes/events-stream-name-position-uniq.sql'
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
end
