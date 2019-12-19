module MessageStore
  module Postgres
    module Controls
      MessageData = MessageStore::Controls::MessageData

      module MessageData
        module Write
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
end
