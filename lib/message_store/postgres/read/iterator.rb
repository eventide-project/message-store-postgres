## Specialize Get
# - This could be injected by reader into iterator
# - Reader knows whether category or not
# - Reader can tell iterator how to get last message
# - Use a block to determine how to get last message position


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
