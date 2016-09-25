module EventStream
  module Postgres
    class EventData
      class Read < EventData
        include Schema::DataStructure

        attribute :stream_name
        attribute :stream_position
        attribute :global_position
        attribute :created_time

        def category
          StreamName.category(stream_name)
        end
      end
    end
  end
end
