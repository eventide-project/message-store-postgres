module MessageStore
  module Postgres
    module Controls
      MessageData = MessageStore::Controls::MessageData

      module MessageData
        module Write
          module List
            Entry = Struct.new(:stream_name, :category, :message_data)

            def self.get(instances: nil)
              instances ||= 1

              stream_name = StreamName.example

              list = []
              instances.times do
                stream_name = Controls::StreamName.example
                category = MessageStore::StreamName.get_category(stream_name)
                write_message = Controls::MessageData::Write.example

                list << Entry.new(stream_name, category, write_message)
              end

              list
            end
          end
        end
      end
    end
  end
end
