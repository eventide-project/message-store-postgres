module EventSource
  module Postgres
    class Log < ::Log
      def tag!(tags)
        tags << :message_store_postgres
        tags << :library
        tags << :verbose
      end
    end
  end
end
