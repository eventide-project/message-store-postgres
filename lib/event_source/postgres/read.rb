module EventSource
  module Postgres
    class Read
      include EventSource::Read

      def self.build_get(stream, batch_size: nil, precedence: nil, partition: nil, session: nil)
        Get.build(stream, batch_size: batch_size, precedence: precedence, partition: partition, session: session)
      end
    end
  end
end
