module EventStream
  module Postgres
    module NoStream
      def self.name
        :no_stream
      end

      def self.version
        -1
      end
    end
  end
end
