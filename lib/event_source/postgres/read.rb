module EventSource
  module Postgres
    class Read
      include EventSource::Read

      def configure(stream, batch_size: nil, precedence: nil, session: nil)
        Get.configure(self, stream, batch_size: batch_size, precedence: precedence, session: session)
      end
    end
  end
end
