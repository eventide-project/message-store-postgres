module Test
  module Interactive
    module Concurrency
      class Defaults
        def self.actors
          Integer(ENV['ACTORS'] || 2)
        end
      end
    end
  end
end
