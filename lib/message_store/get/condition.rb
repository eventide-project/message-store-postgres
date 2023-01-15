module MessageStore
  module Get
    module Condition
      Error = Class.new(RuntimeError)

      def self.error(error_message)
        if error_message.start_with?('Retrieval with SQL condition is not activated')
          Get::Condition::Error.new(error_message)
        end
      end
    end
  end
end
