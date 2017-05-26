module MessageStore
  module Postgres
    class Read
      class Iterator
        include MessageStore::Read::Iterator

        def last_position
          unless MessageStore::Postgres::StreamName.category?(stream_name)
            batch.last.position
          else
            batch.last.global_position
          end
        end
      end
    end
  end
end
