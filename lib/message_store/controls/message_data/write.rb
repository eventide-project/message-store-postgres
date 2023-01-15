module MessageStore
  module Controls
    module MessageData
      module Write
        def self.example(id: nil, type: nil, data: nil, metadata: nil)
          if id == :none
            id = nil
          else
            id ||= self.id
          end

          type ||= self.type

          if data == :none
            data = nil
          else
            data ||= self.data
          end

          if metadata == :none
            metadata = nil
          else
            metadata ||= self.metadata
          end

          message_data = MessageStore::MessageData::Write.build

          message_data.id = id
          message_data.type = type
          message_data.data = data
          message_data.metadata = metadata

          message_data
        end

        def self.id
          MessageData.id
        end

        def self.type
          MessageData.type
        end

        def self.data
          MessageData.data
        end

        def self.metadata
          MessageData::Metadata.data
        end

        module List
          Entry = Struct.new(:stream_name, :category, :message_data)

          def self.get(instances: nil, stream_name: nil, category: nil)
            instances ||= 1

            list = []
            instances.times do
              instance_stream_name = stream_name || StreamName.example(category: category)
              instance_category = MessageStore::StreamName.get_category(instance_stream_name)

              write_message = Controls::MessageData::Write.example

              list << Entry.new(instance_stream_name, instance_category, write_message)
            end

            list
          end
        end
      end
    end
  end
end
