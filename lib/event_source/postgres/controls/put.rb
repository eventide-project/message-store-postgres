module EventSource
  module Postgres
    module Controls
      module Put
        def self.call(instances: nil, stream_name: nil, event: nil, category: nil)
          instances ||= 1
          stream_name ||= StreamName.example(category: category)

          event_specified = !event.nil?

          event ||= EventData::Write.example

          instances.times do
            EventSource::Postgres::Put.(event, stream_name)

            unless event_specified
              event.id = EventData::Write.id
            end
          end

          stream_name
        end
      end
    end
  end
end
