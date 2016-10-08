module EventSource
  module Postgres
    class Log < ::Log
      def tag!(tags)
        tags << :event_source_postgres
        tags << :verbose
      end
    end
  end
end
