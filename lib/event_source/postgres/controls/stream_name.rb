module EventStream
  module Postgres
    module Controls
      module StreamName
        def self.example(category: nil, id: nil, randomize_category: nil)
          category ||= Category.example category: category, randomize_category: randomize_category
          id ||= Identifier::UUID.random

          "#{category}-#{id}"
        end
      end
    end
  end
end
