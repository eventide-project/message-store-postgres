module MessageStore
  module Controls
    module MessageData
      def self.id
        ID::Random.example
      end

      def self.type
        'SomeType'
      end

      def self.other_type
        'SomeOtherType'
      end

      def self.data
        { :attribute => RandomValue.example }
      end
    end
  end
end
