module EventSource
  module Postgres
    class Read
      class Iterator
        include EventSource::Read::Iterator

        def last_position
          unless EventSource::StreamName.category?(stream_name)
            batch.last.position
          else
            batch.last.global_position
          end
        end
      end
    end
  end
end
