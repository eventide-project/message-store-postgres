module MessageStore
  module Postgres
    module Get
      class Stream
        include Get

        def self.command_text(parameters)
          "SELECT * FROM get_stream_messages(#{parameters});"
        end

        def last_position(batch)
          batch.last.position
        end
      end
    end
  end
end
