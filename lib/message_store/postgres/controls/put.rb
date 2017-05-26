module MessageStore
  module Postgres
    module Controls
      module Put
        def self.call(instances: nil, stream_name: nil, message: nil, category: nil)
          instances ||= 1
          stream_name ||= StreamName.example(category: category)

          message_specified = !message.nil?

          message ||= MessageData::Write.example

          instances.times do
            MessageStore::Postgres::Put.(message, stream_name)

            unless message_specified
              message.id = MessageData::Write.id
            end
          end

          stream_name
        end
      end
    end
  end
end
