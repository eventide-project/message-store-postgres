module MessageStore
  module Controls
    module RandomValue
      def self.example
        SecureRandom.hex
      end
    end
  end
end
