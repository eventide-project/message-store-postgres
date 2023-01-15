module MessageStore
  module Controls
    module Category
      def self.example(category: nil, type: nil, types: nil, randomize_category: nil)
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

        category = Controls::StreamName.stream_name(category, type: type, types: types)

        category
      end
    end
  end
end
