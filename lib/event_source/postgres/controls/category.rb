module EventStream
  module Postgres
    module Controls
      module Category
        def self.example(category: nil, randomize_category: nil)
          if randomize_category.nil?
            if !category.nil?
              randomize_category = false
            end
          end

          randomize_category = true if randomize_category.nil?

          category ||= 'Test'

          if randomize_category
            category = "#{category}#{Identifier::UUID.random.gsub('-', '')}"
          end

          category
        end
      end
    end
  end
end
