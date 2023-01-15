module MessageStore
  module Controls
    module Put
      def self.call(instances: nil, stream_name: nil, message_data: nil, message: nil, category: nil, type: nil)
        instances ||= 1
        stream_name ||= StreamName.example(category: category)
        message_data ||= message

        message_specified = !message_data.nil?

        message_data ||= MessageData::Write.example(type: type)

        position = nil
        instances.times do
          position = MessageStore::Put.(message_data, stream_name)

          unless message_specified
            message_data.id = MessageData::Write.id
          end
        end

        [stream_name, position]
      end
    end
  end
end
