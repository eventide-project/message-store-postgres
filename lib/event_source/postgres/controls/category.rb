# module EventSource
#   module Postgres
#     module Controls
#       Category = EventSource::Controls::Category
#     end
#   end
# end


module EventSource
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

          category ||= 'test'

          if randomize_category
            category = "#{category}#{SecureRandom.hex(16)}XX"
          end

          category
        end
      end
    end
  end
end
