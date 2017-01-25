module EventSource
  module Postgres
    class Read
      include EventSource::Read

      def configure(batch_size: nil, session: nil)
        Get.configure(self, batch_size: batch_size, session: session)
      end
    end
  end
end
