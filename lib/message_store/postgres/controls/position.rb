module MessageStore
  module Postgres
    module Controls
      module Position
        def self.example
          1
        end

        def self.max
          (2 ** 63) - 1
        end
      end
    end
  end
end
