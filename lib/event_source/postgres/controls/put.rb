module EventSource
  module Postgres
    module Controls
      module Put
        def self.call(instances: nil, stream_name: nil, event: nil, category: nil, partition: nil)
          instances ||= 1
          stream_name ||= StreamName.example(category: category)
          event ||= EventData::Write.example
          partition ||= Postgres::Partition::Defaults.name

          instances.times do
            EventSource::Postgres::Put.(event, stream_name, partition: partition)
          end

          EventSource::Stream.new(stream_name)
        end
      end
    end
  end
end
