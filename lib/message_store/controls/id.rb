module MessageStore
  module Controls
    module ID
      def self.example(i=nil, increment: nil, sample: nil)
        Identifier::UUID::Controls::Incrementing.example(i=nil, increment: nil, sample: nil)
      end

      Random = Identifier::UUID::Controls::Random
    end
  end
end
