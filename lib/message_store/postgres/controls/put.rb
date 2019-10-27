module MessageStore
  module Postgres
    module Controls
      module Put
        def self.call(instances: nil, stream_name: nil, message_data: nil, message: nil, category: nil)
          instances ||= 1
          stream_name ||= StreamName.example(category: category)
          message_data ||= message

          message_specified = !message_data.nil?

          message_data ||= MessageData::Write.example

          position = nil
          instances.times do
            position = MessageStore::Postgres::Put.(message_data, stream_name)

            unless message_specified
              message_data.id = MessageData::Write.id
            end
          end

          [stream_name, position]
        end
      end
    end
  end
end
