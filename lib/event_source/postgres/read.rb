module EventSource
  module Postgres
    class Read
      include EventSource::Read

      def configure(batch_size: nil, session: nil)
        Iterator.configure(self, self.stream_name, position: self.position)
        Get.configure(self.iterator, batch_size: batch_size, session: session)
      end
    end
  end
end
