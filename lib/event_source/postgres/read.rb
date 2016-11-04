module EventSource
  module Postgres
    class Read
      include EventSource::Read

      def configure(stream, batch_size: nil, precedence: nil, partition: nil, session: nil)
        Get.configure(self, stream, batch_size: batch_size, precedence: precedence, partition: partition, session: session)
      end
    end
  end
end
