module MessageStore
  module Postgres
    module Controls
      MessageData = MessageStore::Controls::MessageData

      module MessageData
        module Write
          module List
            Entry = Struct.new(:stream_name, :message_data)

            def self.get(instances: nil)
              instances ||= 1

              stream_name = StreamName.example

              list = []
              instances.times do
                stream_name = Controls::StreamName.example
                write_message = Controls::MessageData::Write.example

                list << Entry.new(stream_name, write_message)
              end

              list
            end
          end
        end
      end
    end
  end
end
