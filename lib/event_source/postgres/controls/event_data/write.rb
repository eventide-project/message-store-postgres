module EventStream
  module Postgres
    module Controls
      module EventData
        module Write
          def self.data
            {
              :type => EventData.type,
              :data => EventData.data,
              :metadata => EventData::Metadata.data
            }
          end

          def self.example(type: nil, data: nil, metadata: nil)
            type ||= EventData.type
            data ||= EventData.data
            metadata ||= EventData::Metadata.data

            event_data = EventStream::Postgres::EventData::Write.build

            event_data.type = type
            event_data.data = data
            event_data.metadata = metadata

            event_data
          end

          module JSON
            def self.data
              data = Write.data
              Casing::Camel.(data, symbol_to_string: true)
            end

            def self.text
              data.to_json
            end
          end
        end
      end
    end
  end
end
