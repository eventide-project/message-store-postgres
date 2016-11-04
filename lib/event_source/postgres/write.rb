module EventSource
  module Postgres
    class Write
      include EventSource::Write

      def configure(partition: nil, session: nil)
        Put.configure(self, partition: partition, session: session)
      end
    end
  end
end
