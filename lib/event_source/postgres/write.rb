module EventSource
  module Postgres
    class Write
      include EventSource::Write

      def configure(session: nil)
        Put.configure(self, session: session)
      end
    end
  end
end
