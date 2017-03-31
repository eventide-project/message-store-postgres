module EventSource
  module Postgres
    module Database
      module SQLCode
        def self.read(filename)
          path = File.join root, filename

          File.read path
        end

        def self.root
          File.expand_path '../../../../database', __dir__
        end
      end
    end
  end
end
