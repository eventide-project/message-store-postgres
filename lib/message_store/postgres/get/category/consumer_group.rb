module MessageStore
  module Postgres
    module Get
      class Category
        module ConsumerGroup
          Error = Class.new(RuntimeError)

          def self.error(error_message)
            if error_message.start_with?('Consumer group size must not be less than 1') ||
                error_message.start_with?('Consumer group member must be less than the group size') ||
                error_message.start_with?('Consumer group member must not be less than 0') ||
                error_message.start_with?('Consumer group member and size must be specified')
              Error.new(error_message)
            end
          end
        end
      end
    end
  end
end
