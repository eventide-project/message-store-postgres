module MessageStore
  module Postgres
    class Read
      include MessageStore::Read

      def configure(session: nil, condition: nil)
        Get.configure(self.iterator, self.stream_name, batch_size: batch_size, condition: condition, session: session)
      end

      module Defaults
        def self.batch_size
          Postgres::Get::Defaults.batch_size
        end
      end
    end
  end
end
