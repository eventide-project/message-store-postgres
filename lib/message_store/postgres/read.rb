module MessageStore
  module Postgres
    class Read
      include MessageStore::Read

      def configure(session: nil)
        Iterator.configure(self, stream_name, position: position)
        Get.configure(self.iterator, batch_size: batch_size, session: session)
      end
    end
  end
end
