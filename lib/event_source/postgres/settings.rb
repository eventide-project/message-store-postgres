module EventStream
  module Postgres
    class Settings < ::Settings
      def self.instance
        @instance ||= build
      end

      def self.data_source
        'settings/event_stream_postgres.json'
      end

      def self.names
        [
          :dbname,
          :host,
          :hostaddr,
          :port,
          :user,
          :password,
          :connect_timeout,
          :options,
          :sslmode,
          :krbsrvname,
          :gsslib,
          :service
        ]
      end
    end
  end
end
