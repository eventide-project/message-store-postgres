module EventSource
  module Postgres
    class Write
      include EventSource::Write

      def self.build_put(partition: nil, session: nil)
        Put.build(partition: partition, session: session)
      end
    end
  end
end
