module EventStream
  module Postgres
    module Controls
      module Put
        def self.call(instances: nil, stream_name: nil, event: nil, category: nil)
          instances ||= 1
          stream_name ||= StreamName.example(category: category)
          event ||= EventData::Write.example

          instances.times do
            EventStream::Postgres::Put.(stream_name, event)
          end

          stream_name
        end
      end
    end
  end
end
