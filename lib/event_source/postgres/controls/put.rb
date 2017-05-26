module EventSource
  module Postgres
    module Controls
      module Put
        def self.call(instances: nil, stream_name: nil, event: nil, category: nil)
          instances ||= 1
          stream_name ||= StreamName.example(category: category)

          event_specified = !event.nil?

          event ||= MessageData::Write.example

          instances.times do
            EventSource::Postgres::Put.(event, stream_name)

            unless event_specified
              event.id = MessageData::Write.id
            end
          end

          stream_name
        end
      end
    end
  end
end
