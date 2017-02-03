module EventSource
  module Postgres
    class Read
      include EventSource::Read

      ## TODO examine args
      def configure(batch_size: nil, session: nil)
        Get.configure(self, batch_size: batch_size, session: session)

        ## TODO examine args
        Iterator.configure self, self.get, self.stream_name, position: self.position
      end
    end
  end
end
