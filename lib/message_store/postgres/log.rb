module MessageStore
  module Postgres
    class Log < ::Log
      def tag!(tags)
        tags << :message_store
      end
    end
  end
end
