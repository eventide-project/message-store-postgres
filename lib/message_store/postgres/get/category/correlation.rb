module MessageStore
  module Postgres
    module Get
      class Category
        module Correlation
          Error = Class.new(RuntimeError)

          def self.error(error_message)
            if error_message.start_with?('Correlation must be a category')
              Error.new(error_message)
            end
          end
        end
      end
    end
  end
end
